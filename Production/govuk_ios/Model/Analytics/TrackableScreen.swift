import Foundation
import UIKit

protocol TrackableScreen {
    var trackingName: String { get }
    var trackingClass: String { get }
    var trackingTitle: String? { get }
    var trackingLanguage: String { get }
}

extension TrackableScreen {
    var trackingLanguage: String {
        Locale.current.analyticsLanguageCode
    }
}

extension TrackableScreen where  Self: UIViewController {
    var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }

    var trackingTitle: String? {
        title
    }
}
