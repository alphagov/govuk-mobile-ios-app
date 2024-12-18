import Foundation
import CoreData
import GOVKit

protocol TopicsRepositoryInterface {
    func save(topics: [TopicResponseItem])
    func fetchFavourites() -> [Topic]
    func fetchAll() -> [Topic]
    func save()
}

struct TopicsRepository: TopicsRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func save(topics: [TopicResponseItem]) {
        let context = coreData.backgroundContext
        deleteOldObjects(topics: topics, context: context)
        createOrUpdateTopics(topics: topics, context: context)
        try? context.save()
    }

    private func deleteOldObjects(topics: [TopicResponseItem],
                                  context: NSManagedObjectContext) {
        let refs = topics.map(\.ref)
        let request = Topic.fetchRequest()
        let predicate = NSPredicate(format: "NOT ref IN %@", refs)
        request.predicate = predicate
        let deletedObjects = try? context.fetch(request)
        deletedObjects?.forEach(context.delete)
    }

    private func createOrUpdateTopics(topics: [TopicResponseItem],
                                      context: NSManagedObjectContext) {
        topics.forEach { topicResponse in
            createOrUpdateTopic(
                responseItem: topicResponse,
                context: context
            )
        }
    }

    func save() {
        try? coreData.viewContext.save()
    }

    func fetchFavourites() -> [Topic] {
        fetch(
            predicate: .init(format: "isFavourite = true"),
            context: coreData.viewContext
        ).fetchedObjects ?? []
    }

    func fetchAll() -> [Topic] {
        fetch(
            predicate: nil,
            context: coreData.viewContext
        ).fetchedObjects ?? []
    }

    private func fetch(ref: String,
                       context: NSManagedObjectContext) -> Topic? {
        fetch(
            predicate: .init(format: "ref = %@", ref),
            context: context
        ).fetchedObjects?.first
    }

    private func createOrUpdateTopic(responseItem: TopicResponseItem,
                                     context: NSManagedObjectContext) {
        let topic = fetch(
            ref: responseItem.ref,
            context: context
        ) ??
        create(context: context)
        topic.update(item: responseItem)
    }

    private func create(context: NSManagedObjectContext? = nil) -> Topic {
        Topic(context: context ?? coreData.viewContext)
    }

    private func fetch(predicate: NSPredicate?,
                       context: NSManagedObjectContext?) -> NSFetchedResultsController<Topic> {
        let fetchContext = context ?? coreData.viewContext
        let request = Topic.fetchRequest()
        request.predicate = predicate
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: fetchContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()
    }
}
