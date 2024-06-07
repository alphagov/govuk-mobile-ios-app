import Foundation
import UIKit

struct TestViewModel {
    @Inject(\.testService) private var service: TestServiceInterface

    let color: UIColor
    let tabTitle: String
    let nextAction: () -> Void
    let modalAction: () -> Void
}
