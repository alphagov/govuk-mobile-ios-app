import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppForcedUpdateCoordinatorTests {
    @Test
    func start_noUpdateRequired_callsDismiss() async {
        await withCheckedContinuation { continuation in
            let response = AppLaunchResponse.arrange(
                minVersion: "1.0.0",
                recommendedVersion: "1.2.0",
                currentVersion: "1.1.0"
            )
            let sut = AppForcedUpdateCoordinator(
                navigationController: UINavigationController(),
                launchResponse: response,
                dismissAction: {
                    continuation.resume()
                }
            )
            sut.start()
        }
    }

    @Test
    func start_updateRequired_doesntCallDismiss() async throws {
        let response = AppLaunchResponse.arrange(
            minVersion: "1.0.0",
            recommendedVersion: "1.2.0",
            currentVersion: "0.1.0"
        )
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppForcedUpdateCoordinator(
                navigationController: UINavigationController(),
                launchResponse: response,
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
