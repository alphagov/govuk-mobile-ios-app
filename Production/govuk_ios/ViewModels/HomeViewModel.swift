import Foundation
import UIKit

struct HomeViewModel {
    var searchButtonPrimaryAction: (() -> Void)?
    var widgets: [WidgetView] {
        [
            searchWidget
        ]
    }

    var searchWidget: WidgetView {
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
    }
}
