import Foundation
import CoreData

protocol ActivityServiceInterface {
    func save(searchItem: SearchItem)
    func deleteAll()
//    func returnContext() -> NSManagedObjectContext
    func fetch() -> NSFetchedResultsController<ActivityItem>
}

struct ActivityService: ActivityServiceInterface {
    private let repository: ActivityRepositoryInterface

    init(repository: ActivityRepositoryInterface) {
        self.repository = repository
    }

    func deleteAll() {
        repository.deleteAllActivities()
    }
//
//    func returnContext() -> NSManagedObjectContext {
//        repository.returnContext()
//    }

    func fetch() -> NSFetchedResultsController<ActivityItem> {
        repository.fetch()
    }

    func save(searchItem: SearchItem) {
        let params = ActivityItemCreateParams(
            searchItem: searchItem
        )
        repository.save(params: params)
    }
}
