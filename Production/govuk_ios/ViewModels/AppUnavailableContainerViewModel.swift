import Foundation
import UIComponents
import UIKit
import GOVKit

class AppUnavailableContainerViewModel: ObservableObject {
    private let urlOpener: URLOpener
    private let appLaunchService: AppLaunchServiceInterface
    let error: AppConfigError?
    private let dismissAction: () -> Void
    @Published var showProgressView: Bool = false

    private(set) var title = String.appAvailability.localized("unavailableTitle")
    private(set) var subheading = String.appAvailability.localized("unavailableSubheading")
    private(set) var buttonTitle = String.appAvailability.localized("goToGovUkButtonTitle")
    private(set) var buttonAccessibilityTitle =
    String.appAvailability.localized("goToGovUkAccessibilityButtonTitle")
    private(set) var buttonAccessibilityHint = String.common.localized("openWebLinkHint")

    var buttonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: buttonTitle,
            action: { [weak self] in
                if self?.error == .networkUnavailable {
                    self?.retry()
                } else {
                    self?.openGovUK()
                }
            }
        )
    }

    init(urlOpener: URLOpener = UIApplication.shared,
         appLaunchService: AppLaunchServiceInterface,
         error: AppConfigError? = nil,
         dismissAction: @escaping () -> Void) {
        self.urlOpener = urlOpener
        self.appLaunchService = appLaunchService
        self.error = error
        self.dismissAction = dismissAction
        handleNetworkError()
    }

    private func handleNetworkError() {
        guard self.error == .networkUnavailable else { return }
        title = String.common.localized("networkUnavailableErrorTitle")
        subheading = String.common.localized("networkUnavailableErrorBody")
        buttonTitle = String.common.localized("networkUnavailableButtonTitle")
        buttonAccessibilityTitle = String.common.localized("networkUnavailableButtonTitle")
        buttonAccessibilityHint = ""
    }

    private func openGovUK() {
        urlOpener.openIfPossible(Constants.API.govukBaseUrl)
    }

    private func retry() {
        showProgressView = true
        appLaunchService.fetch { [weak self] result in
            if case .success = result.configResult {
                self?.dismissAction()
            }
            self?.showProgressView = false
        }
    }
}
