import Foundation
import SwiftUI
import GOVKit
import UIComponents

protocol InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface? { get }
    var title: String { get }
    var subtitle: String { get }
    var buttonTitle: String { get }
    var buttonAccessibilityTitle: String { get }
    var buttonViewModel: GOVUKButton.ButtonViewModel { get }
    var buttonConfiguration: GOVUKButton.ButtonConfiguration { get }
    var image: AnyView { get }
    var trackingName: String { get }
    var trackingTitle: String { get }
    var showImageWhenCompact: Bool { get }
    var subtitleFont: Font { get }
}

extension InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface? { nil }
    var trackingName: String { "" }
    var trackingTitle: String { "" }

    var buttonConfiguration: GOVUKButton.ButtonConfiguration {
        .primary
    }

    var buttonAccessibilityTitle: String {
        buttonTitle
    }

    func trackScreen(screen: TrackableScreen) {
        if let analyticsService = analyticsService {
            analyticsService.track(screen: screen)
        }
    }
}
