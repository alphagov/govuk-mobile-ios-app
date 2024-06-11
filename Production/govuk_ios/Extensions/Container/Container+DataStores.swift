import Foundation

import Factory

extension Container {
    var testDataStore: Factory<TestDataStoreInterface> {
        Factory(self) {
            TestDataStore()
        }
    }
}
