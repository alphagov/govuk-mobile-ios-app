import Foundation
import CoreData

protocol ActivityServiceInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem>
    func save(activity: ActivityItemCreateParams)
    func delete(objectIds: [NSManagedObjectID])
    func returnContext() -> NSManagedObjectContext
    func activityItem(for objectId: NSManagedObjectID) throws -> ActivityItem?
}

struct ActivityService: ActivityServiceInterface {
    private let repository: ActivityRepositoryInterface

    init(repository: ActivityRepositoryInterface) {
        self.repository = repository
    }

    func fetch() -> NSFetchedResultsController<ActivityItem> {
        repository.fetch()
    }

    func save(activity: ActivityItemCreateParams) {
        repository.save(params: activity)
    }

    func returnContext() -> NSManagedObjectContext {
        repository.returnContext()
    }

    func delete(objectIds: [NSManagedObjectID]) {
        repository.delete(objectIds: objectIds)
    }

    func activityItem(for objectId: NSManagedObjectID) throws -> ActivityItem? {
        try repository.activityItem(for: objectId)
    }
}
