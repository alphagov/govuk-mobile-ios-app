import Foundation
import CoreData

@testable import govuk_ios

extension CoreDataRepository {
    static var arrangeAndLoad: CoreDataRepository {
        arrange().load()
    }

    static var arrange: CoreDataRepository {
        arrange()
    }

    static func arrange(notificationCenter: NotificationCenter = .default) -> CoreDataRepository {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        let url = Bundle.main.url(
            forResource: "GOV",
            withExtension: "momd"
        )!
        let model = NSManagedObjectModel(contentsOf: url)!
        let container = NSPersistentContainer(
            name: "GOV",
            managedObjectModel: model
        )
        container.persistentStoreDescriptions = [description]

        return .init(
            persistentContainer: container,
            notificationCenter: notificationCenter
        )
    }
}
