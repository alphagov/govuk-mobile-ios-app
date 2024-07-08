import Foundation
import UIKit

class ViewControllerBuilder {
    func red(showNextAction: @escaping () -> Void,
             showModalAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TestViewModel(
            color: .red,
            tabTitle: "Red",
            primaryTitle: "Next",
            primaryAction: showNextAction,
            secondaryTitle: "Modal",
            secondaryAction: showModalAction
        )
        return TestViewController(
            viewModel: viewModel
        )
    }

    func driving(showPermitAction: @escaping () -> Void,
                 presentPermitAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TestViewModel(
            color: .cyan,
            tabTitle: "Driving",
            primaryTitle: "Push Permit",
            primaryAction: showPermitAction,
            secondaryTitle: "Modal Permit",
            secondaryAction: presentPermitAction
        )
        return TestViewController(
            viewModel: viewModel
        )
    }

    func launch(completion: @escaping () -> Void) -> UIViewController {
        let viewModel = LaunchViewModel(
            animationCompleted: completion
        )
        return LaunchViewController(
            viewModel: viewModel
        )
    }
}
