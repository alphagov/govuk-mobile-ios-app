import Foundation
import UIComponents
import GOVKit
import SwiftUI

class AmbiguousAuthoritySelectionViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let postCode: String
    private let ambiguousAuthorities: AmbiguousAuthorities
    @Published var localAuthorities: [Authority] = []
    @Published var selectedAuthority: Authority?

    private let selectAddressAction: () -> Void
    let dismissAction: () -> Void

    let title = String.localAuthority.localized("ambiguousLocalAuthorityViewTitle")

    lazy var subtitle = {
        let format = String.localAuthority.localized("ambiguousLocalAuthorityViewSubtitle")
        return String.localizedStringWithFormat(format, postCode)
    }()

    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )

    init(analyticsService: AnalyticsServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         ambiguousAuthorities: AmbiguousAuthorities,
         postCode: String,
         selectAddressAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void
    ) {
        self.localAuthorityService = localAuthorityService
        self.analyticsService = analyticsService
        self.ambiguousAuthorities = ambiguousAuthorities
        self.localAuthorities = ambiguousAuthorities.authorities
        self.postCode = postCode
        self.selectAddressAction = selectAddressAction
        self.dismissAction = dismissAction
    }

    var confirmButtonModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: String.localAuthority.localized(
                "ambiguousLocalAuthorityPrimaryButtonTitle"
            ),
            action: { [weak self] in
                guard let selectedAuthority = self?.selectedAuthority else {
                    return
                }
                self?.localAuthorityService.saveLocalAuthority(selectedAuthority)
                self?.dismissAction()
            }
        )
    }

    var selectAddressButtonModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: String.localAuthority.localized(
                "ambiguousLocalAuthoritySecondaryButtonTitle"
            ),
            action: { [weak self] in
                guard let self = self else { return }
                self.selectAddressAction()
            }
        )
    }
}
