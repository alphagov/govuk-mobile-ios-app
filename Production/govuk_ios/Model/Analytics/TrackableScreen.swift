import Foundation
import UIKit

protocol TrackableScreen {
    nonisolated var trackingName: String { get }
    nonisolated var trackingClass: String { get }
    nonisolated var trackingTitle: String? { get }
    nonisolated var trackingLanguage: String { get }
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
