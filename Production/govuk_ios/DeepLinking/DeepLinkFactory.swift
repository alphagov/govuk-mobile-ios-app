//

import Foundation
import UIKit

struct DeepLinkFactory {
    private let deepLinkStore: DeepLinkStore

    init(deepLinkStore: DeepLinkStore) {
        self.deepLinkStore = deepLinkStore
    }

    func fetchDeepLink(path: String) -> DeepLink? {
        deepLinkStore.returnDeepLinks()
            .first { $0.path == path }
    }
}
