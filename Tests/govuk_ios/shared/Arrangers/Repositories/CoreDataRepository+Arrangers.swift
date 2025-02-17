import Foundation
import CoreData
import Factory
import GOVKit
@testable import govuk_ios

extension CoreDataRepository {
    static var arrangeAndLoad: CoreDataRepository {
        arrange().load()
    }

    static var arrange: CoreDataRepository {
        arrange()
    }

    static func arrange(notificationCenter: NotificationCenter = .default) -> CoreDataRepository {
        let container = NSPersistentContainer(
            name: "GOV",
            managedObjectModel: Container.shared.coreDataModel.resolve()
        )
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        return .init(
            persistentContainer: container,
            notificationCenter: notificationCenter
        )
    }
    
}
