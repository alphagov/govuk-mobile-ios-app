import Foundation
import UIComponents
import UIKit

class AppUnavailableContainerViewModel: ObservableObject {
    private let urlOpener: URLOpener

    let title = String.appAvailability.localized("unavailableTitle")
    let subheading = String.appAvailability.localized("unavailableSubheading")
    let goToGovUkButtonTitle = String.appAvailability.localized("goToGovUkButtonTitle")
    let goToGovUkAccessibilityButtonTitle =
    String.appAvailability.localized("goToGovUkAccessibilityButtonTitle")
    let goToGovUkAccessibilityButtonHint = String.common.localized("openWebLinkHint")

    var goToGovUkButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: goToGovUkButtonTitle,
            action: { [weak self] in
                self?.openGovUK()
            }
        )
    }

    init(urlOpener: URLOpener = UIApplication.shared) {
        self.urlOpener = urlOpener
    }

    private func openGovUK() {
        urlOpener.openIfPossible(Constants.API.govukBaseUrl)
    }
}
