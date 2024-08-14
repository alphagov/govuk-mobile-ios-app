import Foundation
import UIKit

struct HomeViewModel {
    var widgets: [HomeWidgetView] {
        [
            searchWidget
        ]
    }

    var searchWidget: HomeWidgetView {
        let viewModel = HomeWidgetViewModel(
            title: "Find government services and information",
            widgetHeight: 106
        )

        let widget = HomeSearchWidgetStackView(
            viewModel: viewModel
        )

        return HomeWidgetView(
            widget: widget
        )
    }
}
