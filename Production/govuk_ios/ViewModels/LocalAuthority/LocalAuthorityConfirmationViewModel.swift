import Foundation
import GOVKit
import SwiftUI
import UIComponents

class LocalAuthorityConfirmationViewModel {
    let analyticsService: AnalyticsServiceInterface
    private let primaryButtonTitle = String.localAuthority.localized(
        "localAuthorityConfirmationPrimaryButton"
    )
     let cancelButtonTitle = String.localAuthority.localized(
        "localAuthorityCancelButton"
    )
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
        "localAuthorityConfirmationTwoTierDescriptionThree"
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
            text: primaryButtonTitle,
            external: true
        )
        analyticsService.track(event: event)
    }
}
