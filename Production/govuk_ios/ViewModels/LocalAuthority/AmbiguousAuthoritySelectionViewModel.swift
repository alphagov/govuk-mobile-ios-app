import Foundation
import UIComponents
import GOVKit
import SwiftUI

class AmbiguousAuthoritySelectionViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let postCode: String

    @Published var localAuthorities: [LocalAuthority] = []
    @Published var selectedAuthority: LocalAuthority?

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
         localAuthorities: [LocalAuthority],
         postCode: String,
         selectAddressAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void
    ) {
        self.localAuthorityService = localAuthorityService
        self.analyticsService = analyticsService
        self.localAuthorities = localAuthorities
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
                self?.selectAddressAction()
            }
        )
    }
}
