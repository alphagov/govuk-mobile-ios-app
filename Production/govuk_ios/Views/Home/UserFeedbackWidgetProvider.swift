import UIKit
import GOVKit

class UserFeedbackWidgetProvider: NSObject,
                                  WidgetProviding {
    var title: String = String.home.localized("feedbackWidgetTitle")
    var urlString: String?
    var actionType: WidgetAction = .custom("userFeedback")
    var widget: WidgetView
    var startViewController: UIViewController.Type?

    override init() {
        let localWidget = WidgetView(useContentAccessibilityInfo: true)
        localWidget.backgroundColor = UIColor.govUK.fills.surfaceCardSelected
        self.widget = localWidget
        super.init()
    }

    func configure(viewModel: WidgetViewModel) {
        let view = UserFeedbackView(viewModel: viewModel)
        widget.addContent(view)
    }
}
