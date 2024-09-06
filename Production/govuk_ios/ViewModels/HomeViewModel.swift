import Foundation
import UIKit

struct HomeViewModel {
    @Inject(\.activityService) private var activityService: ActivityServiceInterface

    let configService: AppConfigServiceInterface
    let searchButtonPrimaryAction: (() -> Void)?
    var widgets: [WidgetView] {
        [
            searchWidget
        ].compactMap { $0 }
    }

    private var searchWidget: WidgetView? {
        guard widgetEnabled(feature: .search)
        else { return nil }

        let viewModel = WidgetViewModel(
            title: "Find government services and information",
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
