import Foundation
import UIComponents
import GOVKit
import SwiftUI

class AmbiguousAddressSelectionViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let ambiguousAuthorities: AmbiguousAuthorities

    @Published var addresses: [LocalAuthorityAddress]
    @Published var selectedAddress: LocalAuthorityAddress?

    let dismissAction: () -> Void
    let navigateToConfirmationView: (Authority) -> Void
    let title = String.localAuthority.localized("addressSelectionViewTitle")
    let subtitle = String.localAuthority.localized("addressSelectionViewSubtitle")
    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )
    init(analyticsService: AnalyticsServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         ambiguousAuthorities: AmbiguousAuthorities,
         navigateToConfirmationView: @escaping (Authority) -> Void,
         dismissAction: @escaping () -> Void) {
        self.localAuthorityService = localAuthorityService
        self.analyticsService = analyticsService
        self.ambiguousAuthorities = ambiguousAuthorities
        self.navigateToConfirmationView = navigateToConfirmationView
        self.dismissAction = dismissAction
        addresses = ambiguousAuthorities.addresses
    }

    var confirmButtonModel: GOVUKButton.ButtonViewModel {
        let buttonTitle = String.localAuthority.localized(
            "addressSelectionPrimaryButtonTitle"
        )
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                guard let selectedAddress = self?.selectedAddress,
                      let selectedAuthority = self?.ambiguousAuthorities.authorities.first(
                        where: {
                            $0.slug == selectedAddress.slug
                        }
                      ) else { return }
                self?.trackNavigationEvent(buttonTitle)
                self?.localAuthorityService.saveLocalAuthority(selectedAuthority)
                self?.navigateToConfirmationView(selectedAuthority)
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
