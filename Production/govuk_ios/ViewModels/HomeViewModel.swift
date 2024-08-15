import Foundation
import UIKit

struct HomeViewModel {
    var widgets: [WidgetView] {
        [
            searchWidget
        ]
    }

    var searchWidget: WidgetView {
        let viewModel = HomeWidgetViewModel(
            title: "Find government services and information",
            widgetHeight: 106
        )

        let widget = SearchWidgetStackView(
            viewModel: viewModel
        )

        return WidgetView(
            widget: widget
        )
    }
}
