import Foundation
import UIKit
import SwiftUI
import Factory

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

    func home(searchButtonPrimaryAction: @escaping () -> Void,
              configService: AppConfigServiceInterface,
              recentActivityPrimaryAction: @escaping () -> Void) -> UIViewController {
        let viewModel = HomeViewModel(
            configService: configService,
            searchButtonPrimaryAction: searchButtonPrimaryAction,
            recentActivityPrimaryAction: recentActivityPrimaryAction
        )
        return HomeViewController(
            viewModel: viewModel
        )
    }

    func settings() -> UIViewController {
        let viewModel = SettingsViewModel()
        return SettingsViewController(
            viewModel: viewModel
        )
    }

    func search(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = SearchViewModel(
            analyticsService: analyticsService
        )
        return SearchViewController(
            viewModel: viewModel
        )
    }

    func  recentActivty(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = RecentActivitiesViewModel(
            analyticsService: analyticsService)
        let context = Container.shared.coreDataRepository.resolve()
            .viewContext
        let view = RecentActivityContainerView(viewModel: viewModel)
            .environment(\.managedObjectContext, context)
        return UIHostingController(rootView: view)
    }
}
