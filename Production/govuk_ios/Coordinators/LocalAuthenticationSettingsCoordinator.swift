import UIKit
import Foundation
import GOVKit

class LocalAuthenticationSettingsCoordinator: BaseCoordinator {
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let authenticationService: AuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let urlOpener: URLOpener

    init(navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         urlOpener: URLOpener) {
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.urlOpener = urlOpener
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        switch localAuthenticationService.deviceCapableAuthType {
        case .faceID:
            faceIdSettings()
        case .touchID:
            touchIdSettings()
        default:
            fatalError("Should never happen")
        }
    }

    private func faceIdSettings() {
        let viewController = viewControllerBuilder.faceIdSettings(
            analyticsService: analyticsService,
            authenticationService: authenticationService,
            localAuthenticationService: localAuthenticationService,
            urlOpener: urlOpener
        )
        push(viewController, animated: true)
    }

    private func touchIdSettings() {
        let viewController = viewControllerBuilder.touchIdSettings(
            analyticsService: analyticsService,
            authenticationService: authenticationService,
            localAuthenticationService: localAuthenticationService,
            urlOpener: urlOpener
        )
        push(viewController, animated: true)
    }
}
