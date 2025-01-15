import Foundation
import CoreData

public protocol ActivityServiceInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem>
    func save(activity: ActivityItemCreateParams)
    func delete(objectIds: [NSManagedObjectID])
}

public struct ActivityService: ActivityServiceInterface {
    private let repository: ActivityRepositoryInterface

    public init(repository: ActivityRepositoryInterface) {
        self.repository = repository
    }

    public func fetch() -> NSFetchedResultsController<ActivityItem> {
        repository.fetch()
    }
    
    public func save(activity: ActivityItemCreateParams) {
        repository.save(params: activity)
    }

    public func delete(objectIds: [NSManagedObjectID]) {
        repository.delete(objectIds: objectIds)
    }
}
