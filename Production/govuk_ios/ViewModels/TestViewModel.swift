import Foundation
import UIKit

struct TestViewModel {
    @LazyInject private(set) var service: TestServiceInterface

    let color: UIColor
    let tabTitle: String
    let nextAction: () -> Void
    let modalAction: () -> Void
}
