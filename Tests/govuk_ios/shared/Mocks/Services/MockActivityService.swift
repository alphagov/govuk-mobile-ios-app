import Foundation
import CoreData

@testable import govuk_ios

class MockActivityService: ActivityServiceInterface {

    var _stubbedResultsController: NSFetchedResultsController<ActivityItem>?
    func fetch() -> NSFetchedResultsController<ActivityItem> {
        return _stubbedResultsController ?? NSFetchedResultsController<ActivityItem>()
    }

    func deleteAll() { }

    var _receivedSaveSearchItem: SearchItem?
    func save(searchItem: SearchItem) {
        _receivedSaveSearchItem = searchItem
    }
}
