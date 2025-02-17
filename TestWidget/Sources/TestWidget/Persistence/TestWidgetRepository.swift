import Foundation
import CoreData
import GOVKit

struct TestWidgetRepository {
    let coreData: CoreDataRepository

    init() {
        let modelURL = Bundle.module.url(
            forResource: "TestWidget",
            withExtension: "momd"
        )!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(
            name: "TestWidget",
            managedObjectModel: model
        )
        let repository = CoreDataRepository(persistentContainer: container,
                                            notificationCenter: .default
        )
        coreData = repository.load()
    }
}
