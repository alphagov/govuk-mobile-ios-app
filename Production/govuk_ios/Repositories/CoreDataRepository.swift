import CoreData
import Foundation

protocol CoreDataRepositoryInterface {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    func load() -> Self
}

class CoreDataRepository: CoreDataRepositoryInterface {
    private let notificationCenter: NotificationCenter
    private let storeName = "GOV"

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(
            managedObjectModel: destinationModel()
        )
        return coordinator
    }()

    func load() -> Self {
        var url: URL = .sqlitePath(storeName: storeName)
        let description = NSPersistentStoreDescription()
        description.url = url
        persistentStoreCoordinator.addPersistentStore(with: description) { _, _ in }
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try? url.setResourceValues(resourceValues)
        addViewObserver()
        addBackgroundObserver()
        return self
    }

    private func destinationModel() -> NSManagedObjectModel {
        let modelURL: URL? = momdURL()
        return NSManagedObjectModel(
            contentsOf: modelURL!
        )!
    }

    private func momdURL() -> URL? {
        guard let url = Bundle.main.url(
            forResource: storeName,
            withExtension: "momd"
        ) else { return nil }
        return url
    }

    private(set) lazy var viewContext: NSManagedObjectContext = {
        let local = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )
        local.persistentStoreCoordinator = persistentStoreCoordinator
        local.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return local
    }()

    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let local = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        local.persistentStoreCoordinator = persistentStoreCoordinator
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
