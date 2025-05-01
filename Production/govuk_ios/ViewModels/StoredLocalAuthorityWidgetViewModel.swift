import Foundation
import GOVKit
import SwiftUI

class StoredLocalAuthorityWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    let localAuthorities: [LocalAuthorityItem]
    let openEditViewAction: () -> Void
    let twoTierAuthorityDescription: String = String.localAuthority.localized(
        "storedLocalAuthorityWidgetDescriptionTwoTier"
    )
    let editButtonTitle = String.common.localized(
        "editButtonTitle"
    )
    let title = String.localAuthority.localized(
        "localServicesTitle"
    )
    let unitaryCardDescription = String.localAuthority.localized(
        "localAuthorityUnitaryCard"
    )
    let localAuthorityCardWebsiteConstant = String.localAuthority.localized(
        "localAuthorityCardWebsiteConstant"
    )
    let localAuthorityTwoTierParentDescription = String.localAuthority.localized(
        "localAuthoritytwoTierParentDescitption"
    )
    let localAuthorityTwoTierChildDescription = String.localAuthority.localized(
        "localAuthorityTwoTierChildDescription"
    )

    private func returnCardDescription(authority: LocalAuthorityItem) -> String {
        if authority.parent != nil {
            return localAuthorityTwoTierChildDescription(
                councilName: authority.name
            )
        } else {
            return localAuthorityTwoTierParentDescription(
                councilName: authority.name
            )
        }
    }
    private func unitaryCardDescription(councilName: String) -> String {
        return "\(unitaryCardDescription) " +
        councilName + " \(localAuthorityCardWebsiteConstant)"
    }

    private func localAuthorityTwoTierParentDescription(councilName: String) -> String {
        localAuthorityTwoTierParentDescription + councilName +
        " \(localAuthorityCardWebsiteConstant)"
    }

    private func localAuthorityTwoTierChildDescription(councilName: String) -> String {
        localAuthorityTwoTierChildDescription + councilName +
        " \(localAuthorityCardWebsiteConstant)"
    }

    init(analyticsService: AnalyticsServiceInterface,
         localAuthorities: [LocalAuthorityItem],
         urlOpener: URLOpener,
         openEditViewAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.localAuthorities = localAuthorities
        self.urlOpener = urlOpener
        self.openEditViewAction = openEditViewAction
    }

    func openURL(url: String, title: String) {
        if let url = URL(string: url) {
            openURLIfPossible(
                url: url,
                eventTitle: title
            )
        }
    }

    func returnCards() -> [StoredLocalAuthorityCardModel] {
        var cardArray: [StoredLocalAuthorityCardModel] = []
        if localAuthorities.count == 1 {
            if let localAuthority = localAuthorities.first {
                let card = StoredLocalAuthorityCardModel(
                    name: localAuthority.name,
                    homepageUrl: localAuthority.homepageUrl,
                    description: unitaryCardDescription(
                        councilName: localAuthority.name
                    )
                )
                cardArray.append(card)
                return cardArray
            }
        } else {
            for item in localAuthorities {
                let card = StoredLocalAuthorityCardModel(
                    name: item.name,
                    homepageUrl: item.homepageUrl,
                    description: returnCardDescription(
                        authority: item
                    )
                )
                cardArray.append(card)
            }
        }
        return cardArray
    }

    private func trackNavigationEvent(_ title: String,
                                      external: Bool) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: external
        )
        analyticsService.track(event: event)
    }

    private func openURLIfPossible(url: URL,
                                   eventTitle: String) {
        if urlOpener.openIfPossible(url) {
            trackNavigationEvent(
                eventTitle,
                external: true
            )
        }
    }
}
