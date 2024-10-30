import Foundation
import CoreData

protocol TopicsRepositoryInterface {
    func save(topics: [TopicResponseItem])
    func fetchFavorites() -> [Topic]
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
        topics.forEach { topicResponse in
            createOrUpdateTopic(
                responseItem: topicResponse,
                context: context
            )
        }
        try? context.save()
    }

    func save() {
        try? coreData.viewContext.save()
    }

    func fetchFavorites() -> [Topic] {
        fetch(
            predicate: .init(format: "isFavorite = true"),
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

    private func create(context: NSManagedObjectContext) -> Topic {
        Topic(context: context)
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
