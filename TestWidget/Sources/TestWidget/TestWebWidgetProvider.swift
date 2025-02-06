import UIKit
import GOVKit

class TestWebWidgetProvider: NSObject,
                             WidgetProviding {
    var title: String = "Go To Google"
    var urlString: String? = "https://www.gooogle.com"
    var actionType: WidgetAction = .url
    var widget: WidgetView
    var startViewController: UIViewController.Type?

    override init() {
        self.widget = WidgetView(useContentAccessibilityInfo: true)
        super.init()
    }

    func configure(viewModel: WidgetViewModel) {
        let view = TestWebWidgetContentView(viewModel: viewModel)
        widget.addContent(view)
    }
}
