import Foundation
import  CoreData
import GOVKit

@testable import govuk_ios

class MockActivityService: ActivityServiceInterface {
    let coreData = CoreDataRepository.arrangeAndLoad
    func returnContext() -> NSManagedObjectContext {
        return coreData.viewContext
    }

    var _receivedSaveActivity: ActivityItemCreateParams?
    func save(activity: ActivityItemCreateParams) {
        _receivedSaveActivity = activity
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
