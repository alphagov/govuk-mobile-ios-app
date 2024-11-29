import UIKit
import Foundation

@testable import govuk_ios

class MockBaseCoordinator: BaseCoordinator,
                           DeeplinkRouteProvider,
                           TabItemCoordinatorInterface {
    convenience init() {
        self.init(navigationController: .init())
    }

    var _startCalled: Bool = false
    override func start(url: URL?) {
        _startCalled = true
    }

    var _childDidFinishHandler: ((BaseCoordinator) -> Void)?
    var _childDidFinishReceivedChild: BaseCoordinator??
    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        _childDidFinishHandler?(child)
        _childDidFinishReceivedChild = child
    }
    
    var _stubbedRoute: ResolvedDeeplinkRoute?
    func route(for: URL) -> ResolvedDeeplinkRoute? {
        _stubbedRoute
    }
    
    var _didReselectTab = false
    func didReselectTab() {
        _didReselectTab = true
    }
}
