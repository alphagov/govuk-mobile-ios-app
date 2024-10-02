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

    static func arrange(notificationCenter: NotificationCenter = .default,
                        bundle: Bundle = .main) -> CoreDataRepository {
        let url = bundle.url(
            forResource: "GOV",
            withExtension: "momd"
        )!
        let model = NSManagedObjectModel(contentsOf: url)!
        let container = NSPersistentContainer(
            name: "GOV",
            managedObjectModel: model
        )
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        return .init(
            persistentContainer: container,
            notificationCenter: notificationCenter
        )
    }
}
