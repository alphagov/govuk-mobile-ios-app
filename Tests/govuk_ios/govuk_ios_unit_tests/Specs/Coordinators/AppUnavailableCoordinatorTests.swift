import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppUnavailableCoordinatorTests {
    @Test
    func start_isAppAvailable_trueCallsDismiss() async {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppAvailable = true
        await withCheckedContinuation { continuation in
            let sut = AppUnavailableCoordinator(
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
    func start_isAppAvailable_falseDoesntCallDismiss() async throws {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppAvailable = false
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppUnavailableCoordinator(
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
