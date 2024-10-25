import Foundation
import CoreData

protocol TopicsRepositoryInterface {
    func saveTopicsList(_ topicResponses: [TopicResponseItem])
    func fetchFavoriteTopics() -> [Topic]
    func fetchAllTopics() -> [Topic]
    func saveChanges()
}

struct TopicsRepository: TopicsRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func saveTopicsList(_ topicResponses: [TopicResponseItem]) {
        let context = coreData.backgroundContext
        let isFirstLaunch = fetchAllTopics().count == 0
        topicResponses.forEach { topicResponse in
            createOrUpdateTopic(
                for: topicResponse,
                in: context
            )
        }
        try? context.save()
    }

    func saveChanges() {
        try? coreData.viewContext.save()
    }

    func fetchFavoriteTopics() -> [Topic] {
        fetch(
            predicate: .init(format: "isFavorite = true"),
            context: coreData.viewContext
        ).fetchedObjects ?? []
    }

    func fetchAllTopics() -> [Topic] {
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
                                     in context: NSManagedObjectContext) {
        guard let topic = fetchTopic(ref: topicResponse.ref,
                                     context: context) else {
            createTopic(
                for: topicResponse,
                in: context)
            return
        }
        topic.title = topicResponse.title
        topic.topicDescription = topicResponse.description
        topic.ref = topicResponse.ref
    }

    private func createTopic(for topicResponse: TopicResponseItem,
                             in context: NSManagedObjectContext) {
        let topic = Topic(context: context)
        topic.ref = topicResponse.ref
        topic.title = topicResponse.title
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
