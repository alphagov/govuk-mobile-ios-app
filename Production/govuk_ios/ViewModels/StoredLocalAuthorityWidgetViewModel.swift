import Foundation
import GOVKit
import SwiftUI

class StoredLocalAuthrorityWidgetViewModel: ObservableObject {
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    let localAuthority: LocalAuthorityItem
    @Published var isTwoTierAuthority: Bool = false
    let openEditViewAction: () -> Void
    let twoTierAuthorityDesction: String = String.localAuthority.localized(
        "StoredLocalAuthorityWidgetDescriptionTwoTier"
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
    let localAuthorityCardWedbsiteConstant = String.localAuthority.localized(
        "localAuthorityCardWebsiteConstant"
    )
    let localAuthoritytwoTierChildDescitption = String.localAuthority.localized(
        "localAuthoritytwoTierChildDescitption"
    )
    let localAuthorityTwoTierParentDescription = String.localAuthority.localized(
        "localAuthorityTwoTierParentDescription"
    )
    private func unitaryCardDescription(councilName: String) -> String {
        return "\(unitaryCardDescription) " +
        councilName + " \(localAuthorityCardWedbsiteConstant)"
    }
    private func localAuthorityTwoTierChildDescitption(councilName: String) -> String {
        localAuthoritytwoTierChildDescitption + councilName +
        " \(localAuthorityCardWedbsiteConstant)"
    }
    private func localAuthorityTwoTierParentDescription(councilName: String) -> String {
        localAuthorityTwoTierParentDescription + councilName +
        " \(localAuthorityCardWedbsiteConstant)"
    }

    init(analyticsService: AnalyticsServiceInterface,
         model: LocalAuthorityItem,
         urlOpener: URLOpener,
         openEditViewAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.localAuthority = model
        self.urlOpener = urlOpener
        self.openEditViewAction = openEditViewAction
        isAuthorityTwoTiew()
    }

    func openURL(url: String, title: String) {
        if let url = URL(string: url) {
            openURLIfPossible(
                url: url,
                eventTitle: title
            )
        }
    }

     func convertModel() -> [StoredLocalAuthorityWidgetCardModel] {
        var cardArray: [StoredLocalAuthorityWidgetCardModel] = []
        if localAuthority.parent == nil {
            let card = StoredLocalAuthorityWidgetCardModel(
                name: localAuthority.name,
                homepageUrl: localAuthority.homepageUrl,
                description: unitaryCardDescription(
                    councilName: localAuthority.name
                )
            )
            cardArray.append(card)
            return cardArray
        } else {
            let childCard = StoredLocalAuthorityWidgetCardModel(
                name: localAuthority.name,
                homepageUrl: localAuthority.homepageUrl,
                description: localAuthorityTwoTierChildDescitption(
                    councilName: localAuthority.name
                )
            )
            cardArray.append(childCard)
            let parentCard = StoredLocalAuthorityWidgetCardModel(
                name: localAuthority.name,
                homepageUrl: localAuthority.homepageUrl,
                description: localAuthorityTwoTierParentDescription(
                    councilName: localAuthority.name
                )
            )
            cardArray.append(parentCard)
            return cardArray
        }
    }

    private func isAuthorityTwoTiew() {
        self.isTwoTierAuthority = localAuthority.parent != nil
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
