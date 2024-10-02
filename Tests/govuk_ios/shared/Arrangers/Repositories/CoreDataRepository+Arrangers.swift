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
        let container = NSPersistentContainer(name: "GOV")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        return .init(
            persistentContainer: container,
            notificationCenter: notificationCenter
        )
    }
}
