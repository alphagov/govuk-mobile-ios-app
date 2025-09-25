import Foundation
import GOVKit
import SwiftUI

class StoredLocalAuthorityWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    let localAuthorities: [LocalAuthorityItem]
    let openEditViewAction: () -> Void
    private let openURLAction: (URL) -> Void

    let title = String.localAuthority.localized(
        "localServicesTitle"
    )
    let editButtonTitle = String.common.localized(
        "editButtonTitle"
    )
    let editButtonAltText = String.localAuthority.localized(
        "localAuthorityEditButtonAltText"
    )
    let twoTierAuthorityDescription: String = String.localAuthority.localized(
        "storedLocalAuthorityWidgetTwoTierDescription"
    )
    private let localAuthorityTwoTierParentDescription = String.localAuthority.localized(
        "localAuthorityTwoTierParentDescription"
    )
    private let localAuthorityTwoTierChildDescription = String.localAuthority.localized(
        "localAuthorityTwoTierChildDescription"
    )

    init(analyticsService: AnalyticsServiceInterface,
         localAuthorities: [LocalAuthorityItem],
         openURLAction: @escaping (URL) -> Void,
         openEditViewAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.localAuthorities = localAuthorities
        self.openURLAction = openURLAction
        self.openEditViewAction = openEditViewAction
    }

    func open(item: StoredLocalAuthorityCardModel) {
        guard let url = URL(string: item.homepageUrl) else { return }
        openURLAction(url)
        trackNavigationEvent(item.name, external: true)
    }

    func cardModels() -> [StoredLocalAuthorityCardModel] {
        localAuthorities.reduce(into: []) { partialResult, localAuthority in
            let localAuthorityDescription = localAuthorities.count > 1 ?
            returnCardDescription(authority: localAuthority) :
            unitaryCardDescription(authorityName: localAuthority.name)
            let card = StoredLocalAuthorityCardModel(
                name: localAuthority.name,
                homepageUrl: localAuthority.homepageUrl,
                description: localAuthorityDescription
            )
            partialResult.append(card)
        }
    }

    private func returnCardDescription(authority: LocalAuthorityItem) -> String {
        authority.parent != nil ?
        localAuthorityTwoTierChildDescription :
        localAuthorityTwoTierParentDescription
    }

    private func unitaryCardDescription(authorityName: String) -> String {
        let format = String.localAuthority.localized("localAuthorityUnitaryCard")
        return String.localizedStringWithFormat(format, authorityName)
    }

    private func trackNavigationEvent(_ title: String,
                                      external: Bool) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: external
        )
        analyticsService.track(event: event)
    }
}
