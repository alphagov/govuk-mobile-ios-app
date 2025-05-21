import Foundation
import UIComponents
import GOVKit
import SwiftUI

class AmbiguousAddressSelectionViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let authorities: AmbiguousAuthorities

    @Published var addresses: [LocalAuthorityAddress]
    @Published var selectedAddress: LocalAuthorityAddress?

    let dismissAction: () -> Void

    let title = String.localAuthority.localized("addressSelectionViewTitle")

    let subtitle = String.localAuthority.localized("addressSelectionViewSubtitle")

    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )

    init(analyticsService: AnalyticsServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         authorities: AmbiguousAuthorities,
         dismissAction: @escaping () -> Void
    ) {
        self.localAuthorityService = localAuthorityService
        self.analyticsService = analyticsService
        self.authorities = authorities
        self.addresses = authorities.addresses
        self.dismissAction = dismissAction
    }

    var confirmButtonModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: String.localAuthority.localized(
                "addressSelectionPrimaryButtonTitle"
            ),
            action: { [weak self] in
                guard let selectedAddress = self?.selectedAddress,
                      let selectedAuthority = self?.authorities.authorities.first(
                        where: {
                            $0.slug == selectedAddress.slug
                        }
                      ) else { return }
                self?.localAuthorityService.saveLocalAuthority(selectedAuthority)
                self?.dismissAction()
            }
        )
    }
}
