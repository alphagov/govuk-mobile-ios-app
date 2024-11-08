import Foundation
import Factory

extension Container {
    var coreDataRepository: Factory<CoreDataRepositoryInterface> {
        Factory(self) {
            CoreDataRepository(
                notificationCenter: .default
            ).load()
        }
        .scope(.singleton)
    }
}
