import Foundation
import UIKit
import SwiftUI
import Factory

class ViewControllerBuilder {
    @MainActor
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

    @MainActor
    func launch(completion: @escaping () -> Void) -> UIViewController {
        let viewModel = LaunchViewModel(
            animationCompleted: completion
        )
        return LaunchViewController(
            viewModel: viewModel
        )
    }

    @MainActor
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

    @MainActor
    func home(searchButtonPrimaryAction: @escaping () -> Void,
              configService: AppConfigServiceInterface,
              recentActivityAction: @escaping () -> Void) -> UIViewController {
        let viewModel = HomeViewModel(
            configService: configService,
            searchButtonPrimaryAction: searchButtonPrimaryAction,
            recentActivityAction: recentActivityAction
        )
        return HomeViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func settings(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = SettingsViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            bundle: .main
        )
        return SettingsViewController(
            viewModel: viewModel
        )
    }

    @MainActor
    func search(analyticsService: AnalyticsServiceInterface,
                searchService: SearchServiceInterface,
                dismissAction: @escaping () -> Void) -> UIViewController {
        let viewModel = SearchViewModel(
            analyticsService: analyticsService,
            searchService: searchService,
            urlOpener: UIApplication.shared
        )
        return SearchViewController(
            viewModel: viewModel,
            dismissAction: dismissAction
        )
    }

    @MainActor
    func recentActivity(analyticsService: AnalyticsServiceInterface) -> UIViewController {
        let viewModel = RecentActivitiesViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared
        )
        let context = Container.shared.coreDataRepository.resolve()
            .viewContext
        let view = RecentActivityContainerView(viewModel: viewModel)
            .environment(\.managedObjectContext, context)
        return HostingViewController(rootView: view)
    }
}
