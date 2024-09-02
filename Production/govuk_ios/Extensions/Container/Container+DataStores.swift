import Foundation
import Logging
import Factory

extension Container {
    var coreDataRepository: Factory<CoreDataRepositoryInterface> {
        Factory(self) {
            CoreDataRepository()
                .load()
        }
    }

    var analyticsPreferenceStore: Factory<AnalyticsPreferenceStore> {
        Factory(self) {
            UserDefaultsPreferenceStore()
        }
    }
}
