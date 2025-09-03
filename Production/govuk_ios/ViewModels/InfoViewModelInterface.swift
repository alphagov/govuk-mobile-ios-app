import Foundation
import SwiftUI
import GOVKit
import UIComponents

protocol InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface? { get }
    var trackingName: String { get }
    var trackingTitle: String { get }

    var navBarHidden: Bool { get }

    var image: AnyView { get }

    var title: String { get }
    var subtitle: String { get }
    var subtitleFont: Font { get }

    var bottomContentText: String? { get }

    var showPrimaryButton: Bool { get }
    var primaryButtonTitle: String { get }
    var primaryButtonAccessibilityTitle: String { get }
    var primaryButtonViewModel: GOVUKButton.ButtonViewModel { get }
    var primaryButtonConfiguration: GOVUKButton.ButtonConfiguration { get }

    var secondaryButtonTitle: String { get }
    var secondaryButtonAccessibilityTitle: String { get }
    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel? { get }
    var secondaryButtonConfiguration: GOVUKButton.ButtonConfiguration { get }
}

extension InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface? { nil }
    var trackingName: String { "" }
    var trackingTitle: String { "" }

    var navBarHidden: Bool { true }

    var subtitle: String { "" }
    var subtitleFont: Font { Font.govUK.body }

    var bottomContentText: String? { nil }

    var showPrimaryButton: Bool { true }
    var primaryButtonConfiguration: GOVUKButton.ButtonConfiguration { .primary }
    var primaryButtonAccessibilityTitle: String { primaryButtonTitle }

    var secondaryButtonTitle: String { "" }
    var secondaryButtonAccessibilityTitle: String { secondaryButtonTitle }
    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel? { nil }
    var secondaryButtonConfiguration: GOVUKButton.ButtonConfiguration { .secondary }

    func trackScreen(screen: TrackableScreen) {
        if let analyticsService = analyticsService {
            analyticsService.track(screen: screen)
        }
    }
}
