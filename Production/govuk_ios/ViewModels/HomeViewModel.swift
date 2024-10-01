import Foundation
import UIKit

struct HomeViewModel {
    let configService: AppConfigServiceInterface
    let topicsService: TopicsServiceInterface
    let searchButtonPrimaryAction: (() -> Void)?
    let recentActivityAction: (() -> Void)?
    let topicsWidgetView = TopicsWidgetView()
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
        widget.addContent(content)
        return widget
    }

    private var searchWidget: WidgetView? {
        guard widgetEnabled(feature: .search)
        else { return nil }

        let title = String.home.localized("searchWidgetTitle")
        let viewModel = WidgetViewModel(
            title: title,
            primaryAction: searchButtonPrimaryAction
        )

        let content = SearchWidgetStackView(
            viewModel: viewModel
        )
        let widget = WidgetView()
        widget.addContent(content)
        return widget
    }

    private var topicsWidget: WidgetView? {
        let content = TopicsWidgetView()
        topicsService.fetchTopics { result in
            switch result {
            case .success(let topics):
                content.topics = topics
            case .failure(let error):
                print(error)
            }
        }
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func widgetEnabled(feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }
}
