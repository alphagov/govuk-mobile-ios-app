import Foundation
import Factory

extension Container {
    var coreDataRepository: Factory<CoreDataRepositoryInterface> {
        Factory(self) {
            CoreDataRepository(
                persistentContainer: .init(name: "GOV"),
                notificationCenter: .default
            ).load()
        }
    }
}
