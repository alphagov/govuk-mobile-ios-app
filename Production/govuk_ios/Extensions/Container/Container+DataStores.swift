import Foundation
import Logging
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

    var analyticsPreferenceStore: Factory<AnalyticsPreferenceStore> {
        Factory(self) {
            UserDefaultsPreferenceStore()
        }
    }
}
