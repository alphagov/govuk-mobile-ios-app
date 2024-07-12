import Foundation

@testable import govuk_ios

extension ResolvedDeeplinkRoute {
    static func mock(parent: MockBaseCoordinator,
                     route: MockDeeplinkRoute = MockDeeplinkRoute(pattern: "/test")) -> ResolvedDeeplinkRoute {
        .init(
            components: .init(sourceURL: URL(string: "www.google.com")!, route: route),
            parent: parent
        )
    }
}
