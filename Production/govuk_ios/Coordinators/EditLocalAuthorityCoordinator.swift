import UIKit
import Foundation
import GOVKit

class EditLocalAuthorityCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let dismissed: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         tintColor: UIColor = UIColor.govUK.text.link,
         dismissed: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.localAuthorityService = localAuthorityService
        self.coordinatorBuilder = coordinatorBuilder
        self.dismissed = dismissed
        navigationController.navigationBar.tintColor = tintColor
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.localAuthorityPostcodeEntryView(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            resolveAmbiguityAction: { [weak self] localAuthorities, postCode in
                self?.navigateToAmbiguousAuthorityView(
                    localAuthorities: localAuthorities,
                    postCode: postCode
                )
            },
            localAuthoritySelected: { [weak self] authority in
                self?.navigateToConfirmationView(localAuthority: authority)
            },
            dismissAction: { [weak self] in
                self?.dismissModal()
            }
        )
        set(viewController, animated: true)
    }

    private func navigateToAmbiguousAuthorityView(localAuthorities: AmbiguousAuthorities,
                                                  postCode: String) {
        let viewController = viewControllerBuilder.ambiguousAuthoritySelectionView(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            localAuthorities: localAuthorities,
            postCode: postCode,
            localAuthoritySelected: { [weak self] selectedAuthority in
                self?.navigateToConfirmationView(
                    localAuthority: selectedAuthority
                )
            },
            selectAddressAction: { [weak self] in
                self?.navigateToAddressView(localAuthorities: localAuthorities)
            },
            dismissAction: { [weak self] in
                self?.dismissModal()
            }
        )
        push(viewController, animated: true)
    }

    private func navigateToAddressView(localAuthorities: AmbiguousAuthorities) {
        let viewController = viewControllerBuilder.ambiguousAddressSelectionView(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            localAuthorities: localAuthorities,
            localAuthoritySelected: { [weak self] authority in
                self?.navigateToConfirmationView(localAuthority: authority)
            },
            dismissAction: { [weak self] in
                self?.dismissModal()
            }
        )
        push(viewController, animated: true)
    }

    private func navigateToConfirmationView(localAuthority: Authority) {
        let viewController = viewControllerBuilder.localAuthorityConfirmationScreen(
            analyticsService: analyticsService,
            localAuthorityItem: localAuthority,
            dismiss: { [weak self] in
                self?.dismissModal()
            }
        )
        push(viewController, animated: true)
    }

    private func dismissModal() {
        root.dismiss(
            animated: true,
            completion: { [weak self] in
                self?.finish()
            }
        )
    }

    override func finish() {
        super.finish()
        dismissed()
    }
}
