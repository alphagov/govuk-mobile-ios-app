import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppForcedUpdateCoordinatorTests {
    @Test
    func start_isAppForcedUpdate_falseCallsDismiss() async {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppForcedUpdate = false
        await withCheckedContinuation { continuation in
            let sut = AppForcedUpdateCoordinator(
                navigationController: UINavigationController(),
                appConfigService: mockAppConfigService,
                dismissAction: {
                    continuation.resume()
                }
            )
            sut.start()
        }
    }

    @Test
    func start_isAppForcedUpdate_trueDoesntCallDismiss() async throws {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppForcedUpdate = true
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppForcedUpdateCoordinator(
                navigationController: UINavigationController(),
                appConfigService: mockAppConfigService,
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
