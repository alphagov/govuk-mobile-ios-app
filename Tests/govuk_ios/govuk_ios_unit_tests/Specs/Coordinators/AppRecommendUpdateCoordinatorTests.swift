import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppRecommendUpdateCoordinatorTests {
    @Test
    func start_dontRecommendUpdate_callsDismiss() async {
        let response = AppLaunchResponse.arrange(
            minVersion: "1.0.0",
            recommendedVersion: "1.2.0",
            currentVersion: "1.4.0"
        )
        await withCheckedContinuation { continuation in
            let sut = AppRecommendUpdateCoordinator(
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
    func start_recommendUpdate_doesntCallDismiss() async throws {
        let response = AppLaunchResponse.arrange(
            minVersion: "1.0.0",
            recommendedVersion: "1.2.0",
            currentVersion: "1.1.0"
        )
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppRecommendUpdateCoordinator(
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
