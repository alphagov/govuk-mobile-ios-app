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
        let isFirstLaunch = fetchAll().count == 0
        topics.forEach { topicResponse in
            createOrUpdateTopic(
                for: topicResponse,
                in: context,
                isFavorite: isFirstLaunch
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

    private func fetchTopic(ref: String,
                            context: NSManagedObjectContext) -> Topic? {
        fetch(
            predicate: .init(format: "ref = %@", ref),
            context: context
        ).fetchedObjects?.first
    }

    private func createOrUpdateTopic(for topicResponse: TopicResponseItem,
                                     in context: NSManagedObjectContext,
                                     isFavorite: Bool) {
        guard let topic = fetchTopic(ref: topicResponse.ref,
                                     context: context) else {
            createTopic(
                for: topicResponse,
                in: context,
                isFavorite: isFavorite
            )
            return
        }
        topic.title = topicResponse.title
    }

    private func createTopic(for topicResponse: TopicResponseItem,
                             in context: NSManagedObjectContext,
                             isFavorite: Bool) {
        let topic = Topic(context: context)
        topic.ref = topicResponse.ref
        topic.title = topicResponse.title
        topic.isFavorite = isFavorite
        topic.topicDescription = topicResponse.description
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
