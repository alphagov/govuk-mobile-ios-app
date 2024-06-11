import Foundation

@testable import govuk_ios

struct MockDeepLinkStore: DeepLinkStore {

    let deeplinks: [any DeepLink]

}
