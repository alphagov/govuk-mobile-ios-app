import Foundation
import UIKit

struct TestViewModel {
    let color: UIColor
    let tabTitle: String

    let primaryTitle: String?
    let primaryAction: (() -> Void)?

    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?
}
