import Foundation
import UIComponents
import GOVKit
import SwiftUI

class AmbiguousAuthoritySelectionViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let postCode: String
    private let ambiguousAuthorities: AmbiguousAuthorities
    let localAuthorities: [Authority]
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
        self.postCode = postCode
        self.selectAddressAction = selectAddressAction
        self.dismissAction = dismissAction
        localAuthorities = ambiguousAuthorities.authorities
    }

    var confirmButtonModel: GOVUKButton.ButtonViewModel {
        let buttonTitle = String.localAuthority.localized(
            "ambiguousLocalAuthorityPrimaryButtonTitle"
        )
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                guard let selectedAuthority = self?.selectedAuthority else {
                    return
                }
                self?.trackNavigationEvent(buttonTitle)
                self?.localAuthorityService.saveLocalAuthority(selectedAuthority)
                self?.dismissAction()
            }
        )
    }

    var selectAddressButtonModel: GOVUKButton.ButtonViewModel {
        let buttonTitle = String.localAuthority.localized(
            "ambiguousLocalAuthoritySecondaryButtonTitle"
        )
        return GOVUKButton.ButtonViewModel(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                self?.trackNavigationEvent(buttonTitle)
                self?.selectAddressAction()
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
