import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppUnavailableCoordinatorTests {
    @Test
    func start_isAppAvailable_true_callsDismiss() async {
        let mockAppLaunchService = MockAppLaunchService()
        await withCheckedContinuation { continuation in
            let sut = AppUnavailableCoordinator(
                navigationController: UINavigationController(),
                appLaunchService: mockAppLaunchService,
                launchResponse: .arrangeAvailable,
                dismissAction: {
                    continuation.resume()
                }
            )
            sut.start()
        }
    }

    @Test
    func start_isAppAvailable_false_doesntCallDismiss() async throws {
        let mockAppLaunchService = MockAppLaunchService()
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppUnavailableCoordinator(
                navigationController: UINavigationController(),
                appLaunchService: mockAppLaunchService,
                launchResponse: .arrangeUnavailable,
                dismissAction: {
                    continuation.resume(throwing: TestError.unexpectedMethodCalled)
                }
            )
            sut.start()
            continuation.resume(returning: true)
        }
        #expect(started)
    }
}
