import Foundation
import UIComponents
import UIKit
import GOVKit

class AppRecommendUpdateContainerViewModel: ObservableObject {
    private let urlOpener: URLOpener
    private let dismissAction: () -> Void

    let title = String.appAvailability.localized("recommendUpdateTitle")
    let subheading = String.appAvailability.localized("recommendUpdateSubheading")
    let updateButtonTitle = String.appAvailability.localized("updateButtonTitle")
    let skipButtonTitle = String.common.localized("skip")

    var updateButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: updateButtonTitle,
            action: { [weak self] in
                self?.openAppInAppStore()
            }
        )
    }

    var skipButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: skipButtonTitle,
            action: { [weak self] in
                self?.finishAppRecommendUpdate()
            }
        )
    }

    init(urlOpener: URLOpener = UIApplication.shared,
         dismissAction: @escaping () -> Void) {
        self.urlOpener = urlOpener
        self.dismissAction = dismissAction
    }

    private func openAppInAppStore() {
        urlOpener.openIfPossible(Constants.API.appStoreAppUrl)
    }

    private func finishAppRecommendUpdate() {
        dismissAction()
    }
}
