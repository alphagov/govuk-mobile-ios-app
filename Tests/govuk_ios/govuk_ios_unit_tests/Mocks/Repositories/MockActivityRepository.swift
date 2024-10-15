import Foundation
import CoreData

@testable import govuk_ios

class MockActivityRepository: ActivityRepositoryInterface {

    var _receivedSaveParams: ActivityItemCreateParams?
    func save(params: ActivityItemCreateParams) {
        _receivedSaveParams = params
    }

    var _stubbedFetchResultsController: NSFetchedResultsController<ActivityItem>!
    func fetch() -> NSFetchedResultsController<ActivityItem> {
        _stubbedFetchResultsController
    }

    var _receivedDeleteObjectIds: [NSManagedObjectID]?
    func delete(objectIds: [NSManagedObjectID]) {
        _receivedDeleteObjectIds = objectIds
    }

    var _receivedDeleteAll: Bool = false
    func deleteAll() {
        _receivedDeleteAll = true
    }
}
