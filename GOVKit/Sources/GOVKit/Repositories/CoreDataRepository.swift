import CoreData
import Foundation

public class CoreDataRepository: CoreDataRepositoryInterface {
    private let persistentContainer: NSPersistentContainer
    private let notificationCenter: NotificationCenter

    public init(persistentContainer: NSPersistentContainer,
         notificationCenter: NotificationCenter) {
        self.persistentContainer = persistentContainer
        self.notificationCenter = notificationCenter
    }

    public func load() -> Self {
        persistentContainer.persistentStoreDescriptions.forEach { [weak self] in
            self?.setDescriptionProtection(description: $0)
            $0.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
            $0.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        }
        persistentContainer.loadPersistentStores(
            completionHandler: { [weak self] description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
                self?.excludeStoreFromiTunesBackup(url: description.url)
            }
        )
        addBackgroundObserver()
        addViewObserver()
        return self
    }

    private func setDescriptionProtection(description: NSPersistentStoreDescription) {
        description.setOption(
            FileProtectionType.complete as NSObject,
            forKey: NSPersistentStoreFileProtectionKey
        )
    }

    private func excludeStoreFromiTunesBackup(url: URL?) {
        guard var url = url else { return }
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try? url.setResourceValues(resourceValues)
    }

    public private(set) lazy var viewContext: NSManagedObjectContext = {
        let local = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )
        local.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        local.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return local
    }()

    public private(set) lazy var backgroundContext: NSManagedObjectContext = {
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
