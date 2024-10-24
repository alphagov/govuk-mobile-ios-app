import CoreData
import Foundation

protocol CoreDataRepositoryInterface {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }

    func load() -> Self
}

class CoreDataRepository: CoreDataRepositoryInterface {
    private let persistentContainer: NSPersistentContainer
    private let notificationCenter: NotificationCenter

    init(persistentContainer: NSPersistentContainer,
         notificationCenter: NotificationCenter) {
        self.persistentContainer = persistentContainer
        self.notificationCenter = notificationCenter
    }

    func load() -> Self {
        persistentContainer.loadPersistentStores(
            completionHandler: { _, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
        )
        addBackgroundObserver()
        addViewObserver()
        return self
    }

    private(set) lazy var viewContext: NSManagedObjectContext = {
        let local = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )
        local.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        local.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return local
    }()

    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let local = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        local.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        local.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return local
    }()

    private func addViewObserver() {
        notificationCenter.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: viewContext,
            queue: .main,
            using: { [weak self] notification in
                self?.backgroundContext.mergeChanges(fromContextDidSave: notification)
            }
        )
    }

    private func addBackgroundObserver() {
        notificationCenter.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: backgroundContext,
            queue: .main,
            using: { [weak self] notification in
                self?.viewContext.mergeChanges(fromContextDidSave: notification)
            }
        )
    }
}
