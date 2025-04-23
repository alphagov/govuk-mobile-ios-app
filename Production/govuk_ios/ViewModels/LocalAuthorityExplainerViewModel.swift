import Foundation
import UIComponents
import GOVKit

class LocalAuthorityExplainerViewModel {
    private let explainerPrimaryButtonTitle: String = String.localAuthority.localized(
        "localAuthorityExplainerViewPrimaryButtonTitle"
    )
    private let analyticsService: AnalyticsServiceInterface
    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )
    let explainerViewTitle: String = String.localAuthority.localized(
        "localAuthorityExplainerViewTitle"
    )
    let explainerViewDescription: String = String.localAuthority.localized(
        "localAuthorityExplainerViewDesciption"
    )
    let navigationTitle: String = String.localAuthority.localized(
        "localAuthorityNavigationTitle"
    )
    let navigateToPosteCodeEntry: () -> Void
    let dismissAction: () -> Void


    init(analyticsService: AnalyticsServiceInterface,
         navigateToPosteCodeEntry: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.navigateToPosteCodeEntry = navigateToPosteCodeEntry
        self.dismissAction = dismissAction
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

    var explainerViewPrimaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: explainerPrimaryButtonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                let buttonTitle = self.explainerPrimaryButtonTitle
                self.trackNavigationEvent(buttonTitle)
                navigateToPosteCodeEntry()
            }
        )
    }
}
