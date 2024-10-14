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
              topicsService: TopicsServiceInterface,
              recentActivityAction: @escaping () -> Void,
              topicAction: @escaping (Topic) -> Void) -> UIViewController {
        let viewModel = HomeViewModel(
            configService: configService,
            topicsService: topicsService,
            searchButtonPrimaryAction: searchButtonPrimaryAction,
            recentActivityAction: recentActivityAction,
            topicAction: topicAction
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
            activityService: Container.shared.activityService.resolve(),
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
            urlOpener: UIApplication.shared,
            analyticsService: analyticsService
        )
        let view = RecentActivityView(viewModel: viewModel)
        return HostingViewController(rootView: view)
    }

    @MainActor
    func topicDetail(topic: Topic,
                     analyticsService: AnalyticsServiceInterface
    ) -> UIViewController {
        var view = TopicDetailView()
        view.topic = topic
        return HostingViewController(rootView: view)
    }
}
