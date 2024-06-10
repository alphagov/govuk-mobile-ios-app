import Foundation

protocol DeepLinkStore {
    var deeplinks: [DeepLink] { get }
}

struct DrivingDeepLinkStore: DeepLinkStore {
    var deeplinks: [any DeepLink] {
        return [
            DrivingDeepLink(),
            PermitDeepLink()
        ]
    }
}

struct TestDeepLinkStore: DeepLinkStore {
    var deeplinks: [any DeepLink] {
        return [
            TestDeepLink()
        ]
    }
}
