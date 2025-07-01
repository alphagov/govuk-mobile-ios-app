import UIKit
import Foundation
import Factory
import GOVKit

class TopicOnboardingCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    private let configService: AppConfigServiceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         configService: AppConfigServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.configService = configService
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard !topicsService.hasOnboardedTopics,
              configService.isFeatureEnabled(key: .topics)
        else { return dismissAction() }

        let topics = topicsService.fetchAll()
        if topics.isEmpty {
            topicsService.fetchRemoteList { [weak self] _ in
                guard let self = self else { return }
                let updatedTopics = self.topicsService.fetchAll()

                guard !updatedTopics.isEmpty
                else { return self.dismissAction() }
                setViewController(topics: updatedTopics)
            }
        } else {
            setViewController(topics: topics)
        }
    }

    private func setViewController(topics: [Topic]) {
        let viewController = viewControllerBuilder.topicOnboarding(
            topics: topics,
            analyticsService: analyticsService,
            topicsService: topicsService,
            dismissAction: { [weak self] in
                self?.topicsService.setHasOnboardedTopics()
                self?.dismissAction()
            }
        )
        set(viewController, animated: true)
    }
}
