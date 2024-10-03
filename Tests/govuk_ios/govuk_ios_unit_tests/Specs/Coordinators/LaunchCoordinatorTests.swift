import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct LaunchCoordinatorTests {
    @Test
    @MainActor
    func start_launchCompletion_callsCompletion() async {
        let mockNavigationController = UINavigationController()
        let mockViewControllerBuilder = ViewControllerBuilder.mock

        let completed = await withCheckedContinuation { @MainActor continuation in
            let subject = LaunchCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                appConfigService: MockAppConfigService(),
                completion: {
                    continuation.resume(returning: true)
                }
            )
            subject.start()
            mockViewControllerBuilder._receivedLaunchCompletion?()
        }
        #expect(completed)
    }

}
