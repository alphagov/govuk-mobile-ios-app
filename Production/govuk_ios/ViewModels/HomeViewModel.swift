import Foundation
import UIKit
import GOVKit

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void
    let searchAction: () -> Void
    let recentActivityAction: () -> Void

    var widgets: [WidgetView] {
        [
            feedbackWidget,
            searchWidget,
            recentActivityWidget,
            topicsWidget
        ].compactMap { $0 }
    }

    private var feedbackWidget: WidgetView {
        let title = String.home.localized("feedbackWidgetTitle")
        let viewModel = UserFeedbackViewModel(
            title: title,
            action: feedbackAction
        )
        let content = UserFeedbackView(viewModel: viewModel)
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardSelected
        widget.addContent(content)
        return widget
    }

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
        widget.addContent(content)
        return widget
    }

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
}
