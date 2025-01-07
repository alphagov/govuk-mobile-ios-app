import Foundation
import CoreData
import RecentActivity
import GOVKit

class TestRepository: CoreDataRepositoryInterface {
    
    private let persistentContainer: NSPersistentContainer
    private let notificationCenter: NotificationCenter = .default
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    
    init() {
        persistentContainer = Self.arrange()
    }
    
    static func arrange() -> NSPersistentContainer {
        let container = NSPersistentContainer(
            name: "RecentActivity",
            managedObjectModel: Self.createModel()
        )
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        
        return container
    }
    
    private static func createModel() -> NSManagedObjectModel {
        let activityEntity = NSEntityDescription()
        activityEntity.name = "ActivityItem"
        activityEntity.managedObjectClassName = NSStringFromClass(ActivityItem.self)

        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType

        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .stringAttributeType
        
        let urlAttribute = NSAttributeDescription()
        urlAttribute.name = "url"
        urlAttribute.attributeType = .stringAttributeType
        
        activityEntity.properties = [dateAttribute, titleAttribute, idAttribute, urlAttribute]
        
        let model = NSManagedObjectModel()
        model.entities = [activityEntity]
        return model
    }
    
    func load() -> Self {
        persistentContainer.loadPersistentStores(completionHandler: { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        })
        addBackgroundObserver()
        addViewObserver()
        return self
    }
    
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
