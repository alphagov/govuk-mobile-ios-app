import Foundation
import CoreData

extension CoreDataRepository {
    public static var govUK: CoreDataRepository {

        let container = NSPersistentContainer(
            name: "GOV",
            managedObjectModel: model
        )

        return CoreDataRepository(
            persistentContainer: container,
            notificationCenter: .default
        ).load()
    }

    private static var model : NSManagedObjectModel {
        let url = Bundle.main.url(
            forResource: "GOV",
            withExtension: "momd"
        )!
        return NSManagedObjectModel(
            contentsOf: url
        )!
    }
}

