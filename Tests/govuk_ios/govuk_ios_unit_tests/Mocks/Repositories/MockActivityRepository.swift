import Foundation
import CoreData

@testable import govuk_ios

class MockActivityRepository: ActivityRepositoryInterface {

    var _stubbedResultsController: NSFetchedResultsController<ActivityItem>?
    func fetch() -> NSFetchedResultsController<ActivityItem> {
        return _stubbedResultsController ?? NSFetchedResultsController<ActivityItem>()
    }

    func deleteAllActivities() { }

    var _receivedSaveParams: ActivityItemCreateParams?
    func save(params: ActivityItemCreateParams) {
        _receivedSaveParams = params
    }

}
