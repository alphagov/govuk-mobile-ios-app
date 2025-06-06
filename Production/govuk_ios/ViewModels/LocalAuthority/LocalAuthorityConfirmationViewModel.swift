import Foundation
import GOVKit
import SwiftUI
import UIComponents

class LocalAuthorityConfirmationViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    private let primaryButtonTitle = "Done"
    let localAuthorityItem: Authority
    let dismiss: () -> Void
    let unitarySuccessTitle: String = String.localAuthority.localized(
        "localAuthoritySuccessUnitaryTitle"
    )
    let unitarySuccessDescription: String = String.localAuthority.localized(
        "localAuthoritySuccessUnitaryDescription"
    )
    let twoTierSucessTitle: String = String.localAuthority.localized(
        "localAuthoritySuccessTwoTierTitle"
    )
    let twoTierSuccessDescriptionOne: String = String.localAuthority.localized(
        "localAuthoritySuccessTwoTierDescriptionOne"
    )
    let twoTierSuccessDescriptionTwo: String = String.localAuthority.localized(
        "localAuthoritySuceessTwoTierDescriptionTwo"
    )
    let twoTierSuccessDescriptionThree: String = String.localAuthority.localized(
        "localAuthoritySuccessTwoTierDescritionThree"
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
                guard let title = self?.primaryButtonTitle else { return }
                self?.trackNavigationEvent(title)
                self?.dismiss()
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
