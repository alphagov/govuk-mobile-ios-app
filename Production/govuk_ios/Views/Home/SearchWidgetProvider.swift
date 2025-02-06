import UIKit
import GOVKit

class SearchWidgetProvider: NSObject,
                            WidgetProviding {
    var title: String = String.home.localized("searchWidgetTitle")
    var urlString: String?
    var actionType: WidgetAction = .custom("search")
    var widget: WidgetView
    var startViewController: UIViewController.Type?

    override init() {
        self.widget = WidgetView(useContentAccessibilityInfo: true)
        super.init()
    }

    func configure(viewModel: WidgetViewModel) {
        let view = SearchWidgetStackView(viewModel: viewModel)
        widget.addContent(view)
    }
}
