import UIKit
import Foundation
import GOVKit

 class LocalAuthorityCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let localAuthorityService: LocalAuthorityServiceInterface
    private let coordinatorBuilder: CoordinatorBuilder

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         localAuthorityService: LocalAuthorityServiceInterface,
         coordinatorBuilder: CoordinatorBuilder) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.localAuthorityService = localAuthorityService
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.localAuthorityExplainerView(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService) { [weak self] in
                self?.navigateToPostCodeEntryView()
            }
        set(viewController, animated: true)
    }

    func navigateToPostCodeEntryView() {
        let viewController = viewControllerBuilder.localAuthorityPostcodeEntryView(
            analyticsService: analyticsService,
            localAuthorityService: localAuthorityService) { [weak self] in
                self?.navigagteToHome()
            }
        push(viewController, animated: true)
    }

     func navigagteToHome() {
         let coordinator = self.coordinatorBuilder.home
         start(coordinator)
     }

    private func dismissModal() {
        root.dismiss(
            animated: true,
            completion: { [weak self] in
                self?.finish()
            }
        )
    }
 }
