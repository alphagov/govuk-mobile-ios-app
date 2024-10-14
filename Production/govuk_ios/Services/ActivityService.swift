import Foundation
import CoreData

protocol ActivityServiceInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem>
    func save(searchItem: SearchItem)
    func delete(objects: [NSManagedObjectID])
    func deleteAll()
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

    func delete(objects: [NSManagedObjectID]) {
        repository.delete(objects: objects)
    }

    func deleteAll() {
        repository.deleteAll()
    }
}
