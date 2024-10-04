import Foundation
import UIComponents
import UIKit

class AppForcedUpdateContainerViewModel: ObservableObject {
    private let urlOpener: URLOpener

    let title = String.appAvailability.localized("forcedUpdateTitle")
    let subheading = String.appAvailability.localized("forcedUpdateSubheading")
    let updateButtonTitle = String.appAvailability.localized("updateButtonTitle")
    let appStoreAppUrl = Constants.API.appStoreAppUrl

    var updateButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: updateButtonTitle,
            action: { [weak self] in
                self?.openAppInAppStore()
            }
        )
    }

    init(urlOpener: URLOpener = UIApplication.shared) {
        self.urlOpener = urlOpener
    }

    func openAppInAppStore() {
        urlOpener.openIfPossible(appStoreAppUrl)
    }
}
