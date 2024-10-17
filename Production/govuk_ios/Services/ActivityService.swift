import Foundation
import CoreData

protocol ActivityServiceInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem>
    func save(searchItem: SearchItem)
    func save(topicContent: TopicDetailResponse.Content)
    func delete(objectIds: [NSManagedObjectID])
}

struct ActivityService: ActivityServiceInterface {
    private let repository: ActivityRepositoryInterface

    init(repository: ActivityRepositoryInterface) {
        self.repository = repository
    }

    func fetch() -> NSFetchedResultsController<ActivityItem> {
        repository.fetch()
    }

    func save(searchItem: SearchItem) {
        let params = ActivityItemCreateParams(
            searchItem: searchItem
        )
        repository.save(params: params)
    }

    func save(topicContent: TopicDetailResponse.Content) {
        let params = ActivityItemCreateParams(
            topicContent: topicContent
        )
        repository.save(params: params)
    }

    func delete(objectIds: [NSManagedObjectID]) {
        repository.delete(objectIds: objectIds)
    }
}
