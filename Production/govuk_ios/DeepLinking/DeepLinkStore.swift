//

import Foundation

struct DeepLinkStore {
    func returnDeepLinks() -> [DeepLink] {
        return [
            TestDeeplink(path: "/test")
        ]
    }
}
