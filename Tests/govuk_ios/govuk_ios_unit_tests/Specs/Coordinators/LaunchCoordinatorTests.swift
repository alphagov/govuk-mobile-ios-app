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
        let mockAppConfigService = MockAppConfigService()
        
        let completed = await withCheckedContinuation { @MainActor continuation in
            let subject = LaunchCoordinator(
                navigationController: mockNavigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                appConfigService: mockAppConfigService,
                completion: {
                    continuation.resume(returning: true)
                }
            )
            subject.start()
            mockAppConfigService._fetchAppConfigCompletion?()
            mockViewControllerBuilder._receivedLaunchCompletion?()
        }
        #expect(completed)
    }

}
