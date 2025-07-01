import Foundation
import SwiftUI
import GOVKit
import UIComponents

protocol InfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface { get }
    var title: String { get }
    var subtitle: String { get }
    var buttonTitle: String { get }
    var buttonViewModel: GOVUKButton.ButtonViewModel { get }
    var image: AnyView { get }
    var trackingName: String { get }
    var trackingTitle: String { get }
    var showImageWhenCompact: Bool { get }
    var subtitleFont: Font { get }
}

extension InfoViewModelInterface {
    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    var versionNumber: String {
        guard let versionNumber = Bundle.main.versionNumber
        else { return "" }
        return "\(String.onboarding.localized("appVersionText")) \(versionNumber)"
    }
}
