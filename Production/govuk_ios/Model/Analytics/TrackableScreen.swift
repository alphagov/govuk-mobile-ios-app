import Foundation
import UIKit
import SwiftUI

protocol TrackableScreen {
    nonisolated var trackingName: String { get }
    nonisolated var trackingClass: String { get }
    nonisolated var trackingTitle: String? { get }
    nonisolated var trackingLanguage: String { get }
    nonisolated var additionalParameters: [String: Any] { get }
}

extension TrackableScreen {
    var trackingLanguage: String {
        Locale.current.analyticsLanguageCode
    }

    var additionalParameters: [String: Any] {
        [:]
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

extension TrackableScreen where  Self: View {
    var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }
}
