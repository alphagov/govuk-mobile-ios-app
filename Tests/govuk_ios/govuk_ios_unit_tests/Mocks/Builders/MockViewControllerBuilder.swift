import Foundation
import UIKit

@testable import govuk_ios

extension ViewControllerBuilder {
    static var mock: MockViewControllerBuilder {
        MockViewControllerBuilder()
    }
}

class MockViewControllerBuilder: ViewControllerBuilder {

    var _stubbedDrivingViewController: UIViewController?
    var _receivedShowPermitAction: (() -> Void)?
    var _receivedPresentPermitAction: (() -> Void)?
    override func driving(showPermitAction: @escaping () -> Void,
                          presentPermitAction: @escaping () -> Void) -> UIViewController {
        _receivedShowPermitAction = showPermitAction
        _receivedPresentPermitAction = presentPermitAction
        return _stubbedDrivingViewController ?? UIViewController()
    }

}
