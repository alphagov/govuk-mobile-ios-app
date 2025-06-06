import Foundation
import GOVKit
import SwiftUI
import UIComponents

class LocalAuthorityConfirmationViewModel {
    let analyticsService: AnalyticsServiceInterface
    private let primaryButtonTitle = "Done"
    let localAuthorityItem: Authority
    let dismiss: () -> Void
    let unitarySuccessTitle: String = String.localAuthority.localized(
        "localAuthorityConfirmationUnitaryTitle"
    )
    let unitarySuccessDescription: String = String.localAuthority.localized(
        "localAuthorityConfirmationUnitaryDescription"
    )
    let twoTierSucessTitle: String = String.localAuthority.localized(
        "localAuthorityConfirmationTwoTierTitle"
    )
    let twoTierSuccessDescriptionOne: String = String.localAuthority.localized(
        "localAuthorityConfirmationTwoTierDescriptionOne"
    )
    let twoTierSuccessDescriptionTwo: String = String.localAuthority.localized(
        "localAuthorityConfirmationTwoTierDescriptionTwo"
    )
    let twoTierSuccessDescriptionThree: String = String.localAuthority.localized(
        "localAuthorityConfirmationTwoTierDescritionThree"
    )
    init(analyticsService: AnalyticsServiceInterface,
         localAuthorityItem: Authority,
         dismiss: @escaping () -> Void) {
        self.localAuthorityItem = localAuthorityItem
        self.analyticsService = analyticsService
        self.dismiss = dismiss
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.trackNavigationEvent()
                self?.dismiss()
            }
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackNavigationEvent() {
        let event = AppEvent.buttonNavigation(
            text: self.primaryButtonTitle,
            external: true
        )
        analyticsService.track(event: event)
    }
}
