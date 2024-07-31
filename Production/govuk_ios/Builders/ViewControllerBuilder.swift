import Foundation
import UIKit

class ViewControllerBuilder {
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

    func home(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = HomeViewModel(analyticsService: analyticsService)
        return HomeViewController(
            viewModel: viewModel
        )
    }

    func settings(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = SettingsViewModel(analyticsService: analyticsService)
        return SettingsViewController(
            viewModel: viewModel
        )
    }
}
