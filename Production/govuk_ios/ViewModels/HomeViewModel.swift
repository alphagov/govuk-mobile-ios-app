import Foundation
import UIKit

struct HomeViewModel {
    let configService: AppConfigService
    let searchButtonPrimaryAction: (() -> Void)?
    var widgets: [WidgetView] {
        [
            searchWidget
        ].compactMap { $0 }
    }

    var searchWidget: WidgetView? {
        if widgetEnabled(feature: .search) {
            let viewModel = HomeWidgetViewModel(
                title: "Find government services and information",
                widgetHeight: 106,
                primaryAction: searchButtonPrimaryAction
            )

            let widget = SearchWidgetStackView(
                viewModel: viewModel
            )

            return WidgetView(
                widget: widget
            )
        } else {
            return nil
        }
    }

    func widgetEnabled(feature: Feature) -> Bool {
        let featureEnabled = configService.isFeatureEnabled(key: feature)
        return featureEnabled
    }
}
