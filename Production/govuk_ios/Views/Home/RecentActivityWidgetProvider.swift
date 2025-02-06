import UIKit
import GOVKit

class RecentActivityWidgetProvider: NSObject,
                                    WidgetProviding {
    var title: String = String.home.localized(
        "recentActivityWidgetTitle"
    )
    var urlString: String?
    var actionType: WidgetAction = .custom("recentActivity")
    var widget: WidgetView
    var startViewController: UIViewController.Type?

    override init() {
        self.widget = WidgetView(useContentAccessibilityInfo: true)
        super.init()
    }

    func configure(viewModel: WidgetViewModel) {
        let view = RecentActivityWidget(viewModel: viewModel)
        widget.addContent(view)
    }
}
