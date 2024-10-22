import Foundation
import UIKit

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let searchAction: () -> Void
    let recentActivityAction: () -> Void

    var widgets: [WidgetView] {
        [
            searchWidget,
            recentActivityWidget,
            topicsWidget
        ].compactMap { $0 }
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
        let widget = WidgetView()
        widget.isAccessibilityElement = true
        widget.accessibilityLabel = content.accessibilityLabel
        widget.accessibilityTraits = content.accessibilityTraits
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
