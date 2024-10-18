import Foundation
import UIKit

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let searchButtonPrimaryAction: (() -> Void)?
    let recentActivityAction: (() -> Void)?
    let topicWidgetViewModel: TopicsWidgetViewModel
    var widgets: [WidgetView] {
        [
            searchWidget,
            recentlyViewedWidget,
            topicsWidget
        ].compactMap { $0 }
    }
    private var recentlyViewedWidget: WidgetView? {
        let title = String.home.localized(
            "recentActivityWidgetLabel"
        )

        let viewModel = WidgetViewModel(
            title: title,
            primaryAction: recentActivityAction
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

    private var searchWidget: WidgetView? {
        guard widgetEnabled(feature: .search)
        else { return nil }

        let title = String.home.localized("searchWidgetTitle")
        let viewModel = WidgetViewModel(
            title: title,
            primaryAction: {
                let event = AppEvent.widgetNavigation(
                    text: "Search"
                )
                self.analyticsService.track(event: event)
                self.searchButtonPrimaryAction?()
            }
        )

        let content = SearchWidgetStackView(
            viewModel: viewModel
        )
        let widget = WidgetView()
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
