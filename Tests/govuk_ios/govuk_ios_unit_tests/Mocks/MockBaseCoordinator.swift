import UIKit
import Foundation

@testable import govuk_ios

class MockBaseCoordinator: BaseCoordinator {

    convenience init() {
        self.init(navigationController: .init())
    }

    var _startCalled: Bool = false
    var _startReceivedURL: String?
    override func start(url: String?) {
        _startCalled = true
        _startReceivedURL = url
    }

    var _childDidFinishHandler: ((BaseCoordinator) -> Void)?
    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        _childDidFinishHandler?(child)
    }
}
