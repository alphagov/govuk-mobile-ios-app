import Foundation
import CoreData

@testable import govuk_ios

extension CoreDataRepository {
    static var model: NSManagedObjectModel = {
        let url = Bundle.main.url(
            forResource: "GOV",
            withExtension: "momd"
        )!
        return NSManagedObjectModel(contentsOf: url)!
    }()

    static var arrangeAndLoad: CoreDataRepository {
        arrange().load()
    }

    static var arrange: CoreDataRepository {
        arrange()
    }

    static func arrange(notificationCenter: NotificationCenter = .default) -> CoreDataRepository {
        let container = NSPersistentContainer(
            name: "GOV",
            managedObjectModel: model
        )
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        return .init(
            notificationCenter: notificationCenter
        )
    }
    
}
