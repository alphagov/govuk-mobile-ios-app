import UIKit
import Foundation
import Testing

@testable import govuk_ios

class MockBaseCoordinator: BaseCoordinator,
                           DeeplinkRouteProvider,
                           TabItemCoordinatorInterface {

    var _stubbedIsEnabled = true
    var isEnabled: Bool {
        _stubbedIsEnabled
    }

    convenience init() {
        self.init(navigationController: .init())
    }

    var _startCalled: Bool = false
    var _receivedStartURL: URL?
    var _startCalledContinuation: CheckedContinuation<Bool, Never>?
    var _startCalledAction: (() -> Void)?
    override func start(url: URL?) {
        _startCalled = true
        _receivedStartURL = url
        _startCalledAction?()
        _startCalledContinuation?.resume(returning: true)
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
    
    var _selectedTab: Int?
    var _previousTab: Int?
    func didSelectTab(_ selectedTabIndex: Int,
                      previousTabIndex: Int) {
        _selectedTab = selectedTabIndex
        _previousTab = previousTabIndex
    }
}
