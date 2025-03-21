import Foundation
import UIKit
import GOVKit
import RecentActivity

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let notificationService: NotificationServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void
    let notificationsAction: () -> Void
    let recentActivityAction: () -> Void
    let urlOpener: URLOpener
    let searchService: SearchServiceInterface
    let activityService: ActivityServiceInterface

    lazy var searchEnabled = featureEnabled(.search)
    lazy var searchViewModel: SearchViewModel = SearchViewModel(
        analyticsService: analyticsService,
        searchService: searchService,
        activityService: activityService,
        urlOpener: urlOpener
    )

    var widgets: [WidgetView] {
        get async {
            await [
                notificationsWidget,
                //            feedbackWidget,  // see https://govukverify.atlassian.net/browse/GOVUKAPP-1220
                recentActivityWidget,
                topicsWidget
            ].compactMap { $0 }
        }
    }

    @MainActor
    private var notificationsWidget: WidgetView? {
        get async {
            guard await notificationService.shouldRequestPermission
            else { return nil }

            let title = String.home.localized("notificationWidgetTitle")
            let viewModel = UserFeedbackViewModel(
                title: title,
                action: notificationsAction
            )
            let content = InformationView(viewModel: viewModel, shouldHideChevron: true)
            let widget = WidgetView(useContentAccessibilityInfo: true)
            widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
            widget.addContent(content)
            return widget
        }
    }

    @MainActor
    private var feedbackWidget: WidgetView {
        let title = String.home.localized("feedbackWidgetTitle")
        let viewModel = UserFeedbackViewModel(
            title: title,
            action: feedbackAction
        )
        let content = InformationView(viewModel: viewModel, shouldHideChevron: false)
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
        widget.addContent(content)
        return widget
    }

    @MainActor
    private var recentActivityWidget: WidgetView? {
        guard featureEnabled(.recentActivity)
        else { return nil }
        let title = String.home.localized(
            "recentActivityWidgetTitle"
        )

        let viewModel = RecentActivityWidgetViewModel(
            title: title,
            action: recentActivityAction
        )
        let content = RecentActivtyWidget(
            viewModel: viewModel
        )
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.addContent(content)
        return widget
    }

    @MainActor
    private var topicsWidget: WidgetView? {
        guard featureEnabled(.topics)
        else { return nil }
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func featureEnabled(_ feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }

    func trackECommerce() {
        topicWidgetViewModel.trackECommerce()
    }
}
