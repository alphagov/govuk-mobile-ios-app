import Foundation
import FactoryKit
import CoreData
import GOVKit

extension Container {
    var coreDataModel: Factory<NSManagedObjectModel> {
        Factory(self) {
            let url = Bundle.main.url(
                forResource: "GOV",
                withExtension: "momd"
            )!
            return NSManagedObjectModel(
                contentsOf: url
            )!
        }
        .scope(.singleton)
    }

    var coreDataRepository: Factory<CoreDataRepositoryInterface> {
        Factory(self) {
            let container = NSPersistentContainer(
                name: "GOV",
                managedObjectModel: self.coreDataModel.resolve()
            )
            return CoreDataRepository(
                persistentContainer: container,
                notificationCenter: .default
            ).load()
        }
        .scope(.singleton)
    }
}
