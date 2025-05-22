import Foundation
import CoreData
import GOVKit

@testable import govuk_ios

class MockCoreDataRepository: CoreDataRepositoryInterface {
    var _mockBackgroundContext: NSManagedObjectContext
    var backgroundContext: NSManagedObjectContext {
        return _mockBackgroundContext
    }

    var _mockViewContext: NSManagedObjectContext
    var viewContext: NSManagedObjectContext {
        _mockViewContext
    }

    var _stubbedLoadCalled = false
    func load() -> Self {
        _stubbedLoadCalled = true
        return self
    }

    init(entities: [NSEntityDescription] = [], storeType: String = NSSQLiteStoreType) {
        let tempDir = NSTemporaryDirectory()
        let uuid = UUID().uuidString
        let tempStoreURL = URL(fileURLWithPath: tempDir).appendingPathComponent(
            "TestStore_\(uuid).sqlite"
        )
        self.storeURL = tempStoreURL
        let managedObjectModel = NSManagedObjectModel()
        managedObjectModel.entities = entities
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: storeType,
                configurationName: nil,
                at: tempStoreURL,
                options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                NSInferMappingModelAutomaticallyOption: true]
            )
        } catch {
            fatalError("Failed to add persistent store: \(error)")
        }

        _mockViewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        _mockViewContext.persistentStoreCoordinator = persistentStoreCoordinator

        _mockBackgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _mockBackgroundContext.persistentStoreCoordinator = persistentStoreCoordinator
    }

    private var storeURL: URL?
    func cleanUp() {
        guard let storeURL = self.storeURL else { return }
        try? FileManager.default.removeItem(at: storeURL)
    }
}
