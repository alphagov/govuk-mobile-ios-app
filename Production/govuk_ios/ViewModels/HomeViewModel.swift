import Foundation
import UIKit

struct HomeViewModel {
    @Inject(\.activityService) private var activityService: ActivityServiceInterface

    let configService: AppConfigServiceInterface
    let searchButtonPrimaryAction: (() -> Void)?
    let recentActivityAction: (() -> Void)?
    var widgets: [WidgetView] {
        [
            searchWidget,
            recentlyViewedWidget
        ].compactMap { $0 }
    }
    private var recentlyViewedWidget: WidgetView? {
        let title = "recentActivityWidgetLabel".localized

        let viewModel = WidgetViewModel(
            title: title,
            primaryAction: recentActivityAction
        )
        let content = RecentActivtyWidgetStackView(
            viewModel: viewModel
        )
        let widget = WidgetView()
        widget.addContent(content)
        return widget
    }

    private var searchWidget: WidgetView? {
        guard widgetEnabled(feature: .search)
        else { return nil }


        let title = "homeSearchWidgetTitle".localized

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

    private func widgetEnabled(feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }
}
