import Foundation

protocol DeepLinkStore {
    var deeplinks: [DeepLinkRoute] { get }
}

struct DrivingDeepLinkStore: DeepLinkStore {
    var deeplinks: [any DeepLinkRoute] {
        return [
            DrivingDeepLink(),
            PermitDeepLink()
        ]
    }
}
