import Foundation
import UIKit

class ViewControllerBuilder {
    func blue(showNextAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TestViewModel(
            color: .blue,
            tabTitle: "Blue",
            primaryTitle: "Next",
            primaryAction: showNextAction,
            secondaryTitle: nil,
            secondaryAction: nil
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

    func permit(permitId: String,
                finishAction: @escaping () -> Void) -> UIViewController {
        let viewModel = TestViewModel(
            color: .lightGray,
            tabTitle: "Permit - \(permitId)",
            primaryTitle: nil,
            primaryAction: nil,
            secondaryTitle: "Dismiss",
            secondaryAction: finishAction
        )
        return TestViewController(
            viewModel: viewModel
        )
    }

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

    func home() -> UIViewController {
        return HomeViewController()
    }

    func settings() -> UIViewController {
        return SettingsViewController()
    }
}
