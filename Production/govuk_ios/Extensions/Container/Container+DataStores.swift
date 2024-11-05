import Foundation
import Factory

extension Container {
    var coreDataRepository: Factory<CoreDataRepositoryInterface> {
        Factory(self) {
            CoreDataRepository(
                persistentContainer: CachePersistentContainer(
                    name: "GOV"
                ),
                notificationCenter: .default
            ).load()
        }
        .scope(.singleton)
    }
}
