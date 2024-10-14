import Foundation
import CoreData

@testable import govuk_ios

class MockActivityService: ActivityServiceInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem> {
        return NSFetchedResultsController<ActivityItem>()
    }

    func deleteAll() { }

    var _receivedSaveSearchItem: SearchItem?
    func save(searchItem: SearchItem) {
        _receivedSaveSearchItem = searchItem
    }
}
