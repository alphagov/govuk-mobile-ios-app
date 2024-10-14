import Foundation
import CoreData

@testable import govuk_ios

class MockActivityService: ActivityServiceInterface {

    func deleteAll() { }

    func returnContext() -> NSManagedObjectContext {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()
        return coreData.backgroundContext
    }

    var _receivedSaveSearchItem: SearchItem?
    func save(searchItem: SearchItem) {
        _receivedSaveSearchItem = searchItem
    }
}
