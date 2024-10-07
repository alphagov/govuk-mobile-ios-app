import UIKit

final class EditTopicsCoordinator: BaseCoordinator {
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let topics: [Topic]
    private let dismissed: () -> Void

    init(navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         topics: [Topic],
         dismissed: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.topics = topics
        self.dismissed = dismissed
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.editTopics(
            topics,
            analyicsService: analyticsService,
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
