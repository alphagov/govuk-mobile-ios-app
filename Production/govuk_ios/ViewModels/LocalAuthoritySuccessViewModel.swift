import Foundation
import GOVKit
import SwiftUI
import UIComponents

class LocalAuthoritySuccessViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    private let primaryButtonTitle = "completion"
    let localAuthorityItem: Authority
    let completion: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         localAuthorityItem: Authority,
         completion: @escaping () -> Void) {
        self.localAuthorityItem = localAuthorityItem
        self.analyticsService = analyticsService
        self.completion = completion
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.completion()
            }
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: true
        )
        analyticsService.track(event: event)
    }
}
