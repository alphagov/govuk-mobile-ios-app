import Foundation
import CoreData

protocol ActivityServiceInterface {
    func save(searchItem: SearchItem)
    func deleteAll()
    func returnContext() -> NSManagedObjectContext
}

struct ActivityService: ActivityServiceInterface {
    private let repository: ActivityRepositoryInterface

    init(repository: ActivityRepositoryInterface) {
        self.repository = repository
    }

    func deleteAll() {
        repository.deleteAllActivities()
    }

    func returnContext() -> NSManagedObjectContext {
        repository.returnContext()
    }

    func save(searchItem: SearchItem) {
        let params = ActivityItemCreateParams(
            searchItem: searchItem
        )
        repository.save(params: params)
    }
}
