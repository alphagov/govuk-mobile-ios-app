import Foundation
import SwiftUI
import GOVKit
import UIComponents

protocol AuthenticationInfoViewModelInterface {
    var analyticsService: AnalyticsServiceInterface { get }
    var title: String { get }
    var subtitle: String { get }
    var buttonTitle: String { get }
    var buttonViewModel: GOVUKButton.ButtonViewModel { get }
    var image: Image? { get }
    var trackingName: String { get }
    var trackingTitle: String { get }
}

extension AuthenticationInfoViewModelInterface {
    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
