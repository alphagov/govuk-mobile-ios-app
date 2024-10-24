import UIKit
import Foundation

class SearchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let appConfigService: AppConfigServiceInterface
    private let searchService: SearchServiceInterface
    private let dismissed: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         appConfigService: AppConfigServiceInterface,
         searchService: SearchServiceInterface,
         dismissed: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.appConfigService = appConfigService
        self.searchService = searchService
        self.dismissed = dismissed
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.search(
            analyticsService: analyticsService,
            appConfigService: appConfigService,
            searchService: searchService,
            dismissAction: { [weak self] in
                self?.dismissModal()
            }
        )
        set(viewController, animated: true)
    }

    private func dismissModal() {
        root.dismiss(
            animated: true,
            completion: { [weak self] in
                self?.dismissed()
            }
        )
    }

    override func finish() {
        super.finish()
        dismissed()
    }
}
