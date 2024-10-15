import Foundation
import  CoreData

@testable import govuk_ios

class MockActivityService: ActivityServiceInterface {
    var _receivedSaveSearchItem: SearchItem?
    func save(searchItem: SearchItem) {
        _receivedSaveSearchItem = searchItem
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
