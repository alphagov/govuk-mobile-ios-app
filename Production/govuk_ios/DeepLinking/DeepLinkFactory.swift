//

import Foundation
import UIKit

struct DeepLinkFactory {
    
    private let deepLinkStore:DeepLinkStore
    private let navigationController: UINavigationController
    
    init(deepLinkStore: DeepLinkStore, navigationController: UINavigationController) {
        self.deepLinkStore = deepLinkStore
        self.navigationController = navigationController
    }
    
    func fetchDeepLink(path:String) -> DeepLink? {
        var deepLink = deepLinkStore.returnDeepLinks().first(where: { $0.path == path })
        deepLink?.navigationController = navigationController
        return deepLink
    }
}
