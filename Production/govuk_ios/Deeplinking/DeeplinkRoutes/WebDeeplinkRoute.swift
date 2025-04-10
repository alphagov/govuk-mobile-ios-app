import Foundation
import UIKit

struct WebDeeplinkRoute: DeeplinkRoute {
    private let dataStore: DeeplinkDataStore

    init(dataStore: DeeplinkDataStore) {
        self.dataStore = dataStore
    }

    var pattern: URLPattern {
        "/web" // Pattern to match web deeplinks
    }

    @MainActor
    func action(parent: BaseCoordinator, params: [String: String]) {
        // The target URL should be in the params
        if let targetUrl = params["url"], let url = URL(string: targetUrl) {
            dataStore.presentDeeplinkPage(for: url)
        }
    }
}
