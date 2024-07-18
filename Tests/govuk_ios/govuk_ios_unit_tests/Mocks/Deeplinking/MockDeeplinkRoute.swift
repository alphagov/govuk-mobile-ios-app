import Foundation

@testable import govuk_ios

class MockDeeplinkRoute: DeeplinkRoute {

    let pattern: URLPattern

    init(pattern: URLPattern) {
        self.pattern = pattern
    }

    var _actionCalled: Bool = false
    func action(parent: BaseCoordinator,
                params: [String : String]) { 
        _actionCalled = true
    }
}
