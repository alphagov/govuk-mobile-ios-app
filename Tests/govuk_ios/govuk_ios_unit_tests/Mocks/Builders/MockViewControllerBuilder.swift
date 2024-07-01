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
    var _receivedDrivingShowPermitAction: (() -> Void)?
    var _receivedDrivingPresentPermitAction: (() -> Void)?
    override func driving(showPermitAction: @escaping () -> Void,
                          presentPermitAction: @escaping () -> Void) -> UIViewController {
        _receivedDrivingShowPermitAction = showPermitAction
        _receivedDrivingPresentPermitAction = presentPermitAction
        return _stubbedDrivingViewController ?? UIViewController()
    }

    var _stubbedRedViewController: UIViewController?
    var _receivedRedShowNextAction: (() -> Void)?
    var _receivedRedShowModalAction: (() -> Void)?
    override func red(showNextAction: @escaping () -> Void,
                      showModalAction: @escaping () -> Void) -> UIViewController {
        _receivedRedShowNextAction = showNextAction
        _receivedRedShowModalAction = showModalAction
        return _stubbedRedViewController ?? UIViewController()
    }

}
