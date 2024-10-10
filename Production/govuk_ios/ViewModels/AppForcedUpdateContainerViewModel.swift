import Foundation
import UIComponents
import UIKit

class AppForcedUpdateContainerViewModel: ObservableObject {
    private let urlOpener: URLOpener

    let title = String.appAvailability.localized("forcedUpdateTitle")
    let subheading = String.appAvailability.localized("forcedUpdateSubheading")
    let updateButtonTitle = String.appAvailability.localized("updateButtonTitle")

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

    private func openAppInAppStore() {
        urlOpener.openIfPossible(Constants.API.appStoreAppUrl)
    }
}
