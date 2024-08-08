import Foundation
import UIKit

protocol TrackableScreen {
    var trackingName: String { get }
    var trackingClass: String { get }
}

extension TrackableScreen where  Self: UIViewController {
    var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }
}
