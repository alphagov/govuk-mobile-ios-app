import Foundation
import GOVKit
import UIKit

public class TestWidgetProvider: NSObject,
                                 WidgetProviding {
    public var title: String = "Test Widget"
    public var urlString: String?
    public var actionType: WidgetAction = .push
    public var widget: WidgetView
    public var startViewController: UIViewController.Type? = TestViewController.self

    public override init() {
        self.widget = WidgetView()
        super.init()
    }

    public func configure(viewModel: WidgetViewModel) {
        widget.addContent(TestWidgetContentView(viewModel: viewModel))
    }
}
