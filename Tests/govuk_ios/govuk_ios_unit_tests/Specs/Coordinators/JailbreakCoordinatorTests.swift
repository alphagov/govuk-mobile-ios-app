import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct JailbreakCoordinatorTests {

    @Test
    func start_isJailbroken_false_callsDismiss() async throws {
        await withCheckedContinuation { continuation in
            let sut = JailbreakCoordinator(
                navigationController: UINavigationController(),
                jailbreakDetectionService: MockJailbreakDetectionService(),
                dismissAction: {
                    continuation.resume()
                }
            )
            sut.start()
        }
    }

    @Test
    func start_isJailbroken_true_doesNotCallDismiss() async throws {
        let jailbreakService = MockJailbreakDetectionService()
        jailbreakService._stubbedIsJailbroken = true
        let result: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = JailbreakCoordinator(
                navigationController: UINavigationController(),
                jailbreakDetectionService: jailbreakService,
                dismissAction: {
                    continuation.resume(throwing: TestError.unexpectedMethodCalled)
                }
            )
            sut.start()
            continuation.resume(returning: true)
        }
        #expect(result)
    }
}
