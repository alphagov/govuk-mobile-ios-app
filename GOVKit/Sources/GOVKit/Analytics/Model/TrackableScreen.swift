import Foundation
import UIKit
import SwiftUI

public protocol TrackableScreen {
    nonisolated var trackingName: String { get }
    nonisolated var trackingClass: String { get }
    nonisolated var trackingTitle: String? { get }
    nonisolated var trackingLanguage: String { get }
    nonisolated var additionalParameters: [String: Any] { get }
}

extension TrackableScreen {
    public var trackingLanguage: String {
        Locale.current.analyticsLanguageCode
    }

    public var additionalParameters: [String: Any] {
        [:]
    }
}

extension TrackableScreen where  Self: UIViewController {
    public var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }

    public var trackingTitle: String? {
        title
    }
}

extension TrackableScreen where  Self: View {
    public var trackingClass: String {
        String(
            describing: type(of: self)
        )
    }
}
