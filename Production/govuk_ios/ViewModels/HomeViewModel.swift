import Foundation
import UIKit
import GOVKit

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let notificationService: NotificationServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void
    let searchAction: () -> Void
    let notificationsAction: () -> Void
    let recentActivityAction: () -> Void

    var widgets: [WidgetView] {
        get async {
            await [
                notificationsWidget,
                //            feedbackWidget,  // see https://govukverify.atlassian.net/browse/GOVUKAPP-1220
                searchWidget,
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

            let title = String.home.localized("homeWidgetTitle")
            let viewModel = UserFeedbackViewModel(
                title: title,
                action: notificationsAction
            )
            let content = UserFeedbackView(viewModel: viewModel)
            content.hideChevron()
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
        let content = UserFeedbackView(viewModel: viewModel)
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
        widget.addContent(content)
        return widget
    }

    @MainActor
    private var searchWidget: WidgetView? {
        guard widgetEnabled(feature: .search)
        else { return nil }

        let title = String.home.localized("searchWidgetTitle")
        let viewModel = SearchWidgetViewModel(
            title: title,
            action: searchAction
        )
        let content = SearchWidgetStackView(
            viewModel: viewModel
        )
        let widget = WidgetView()
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardDefault
        widget.addContent(content)
        return widget
    }

    @MainActor
    private var recentActivityWidget: WidgetView? {
        guard widgetEnabled(feature: .recentActivity)
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
        guard widgetEnabled(feature: .topics)
        else { return nil }
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func widgetEnabled(feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }

    func trackECommerce() {
        topicWidgetViewModel.trackECommerce()
    }
}
