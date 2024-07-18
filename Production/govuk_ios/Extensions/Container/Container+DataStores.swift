import Foundation
import Logging
import Factory

extension Container {
    var testDataStore: Factory<TestDataStoreInterface> {
        Factory(self) {
            TestDataStore()
        }
    }

    var analyticsPreferenceStore: Factory<AnalyticsPreferenceStore> {
        Factory(self) {
            UserDefaultsPreferenceStore()
        }
    }
}
