import UIKit
import Foundation

@testable import govuk_ios

class MockBaseCoordinator: BaseCoordinator,
                           DeeplinkRouteProvider {

    convenience init() {
        self.init(navigationController: .init())
    }

    var _startCalled: Bool = false
    override func start(url: URL?) {
        _startCalled = true
    }

    var _childDidFinishHandler: ((BaseCoordinator) -> Void)?
    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        _childDidFinishHandler?(child)
    }
    
    var _stubbedRoute: ResolvedDeeplinkRoute?
    func route(for: URL) -> ResolvedDeeplinkRoute? {
        _stubbedRoute
    }

}
