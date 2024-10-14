import Foundation
import CoreData

@testable import govuk_ios

class MockActivityRepository: ActivityRepositoryInterface {

    func deleteAllActivities() { }

    func returnContext() -> NSManagedObjectContext {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()
        return coreData.backgroundContext
    }


    var _receivedSaveParams: ActivityItemCreateParams?
    func save(params: ActivityItemCreateParams) {
        _receivedSaveParams = params
    }

}
