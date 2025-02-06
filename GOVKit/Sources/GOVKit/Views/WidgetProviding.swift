import Foundation
import UIKit

public enum WidgetAction {
    case push
    case url
    case present
    case custom(String)
}

public protocol WidgetProviding {
    var title: String { get }
    var actionType: WidgetAction { get }
    var widget: WidgetView { get }
    var startViewController: UIViewController.Type? { get }
    var urlString: String? { get }
    func configure(viewModel: WidgetViewModel)
}
