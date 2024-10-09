import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppRecommendUpdateCoordinatorTests {
    @Test
    func start_dontRecommendUpdate_callsDismiss() async {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppRecommendUpdate = false
        await withCheckedContinuation { continuation in
            let sut = AppRecommendUpdateCoordinator(
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
    func start_recommendUpdate_doesntCallDismiss() async throws {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppRecommendUpdate = true
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppRecommendUpdateCoordinator(
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
