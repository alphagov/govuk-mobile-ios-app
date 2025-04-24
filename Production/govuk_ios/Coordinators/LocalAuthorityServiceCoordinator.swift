import UIKit
import Foundation
import GOVKit

 class LocalAuthorityServiceCoordinator: BaseCoordinator {
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
         dismissed: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.localAuthorityService = localAuthorityService
        self.coordinatorBuilder = coordinatorBuilder
        self.dismissed = dismissed
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.localAuthorityExplainerView(
            analyticsService: analyticsService,
            navigateToPostCodeEntryViewAction: { [weak self] in
                self?.navigateToPostcodeEntryView()
            },
            dismissAction: { [weak self] in
                self?.dismissModal()
            }
        )
        set(viewController, animated: true)
    }

    func navigateToPostcodeEntryView() {
        let viewController = viewControllerBuilder.localAuthorityPostcodeEntryView(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService,
            dismissAction: { [weak self] in
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
