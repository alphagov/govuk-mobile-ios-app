import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AppUnavailableCoordinatorTests {
    @Test
    func start_isAppAvailable_true_callsDismiss() async {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppAvailable = true
        await withCheckedContinuation { continuation in
            let sut = AppUnavailableCoordinator(
                navigationController: UINavigationController(),
                appConfigService: mockAppConfigService,
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
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppAvailable = false
        let started: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = AppUnavailableCoordinator(
                navigationController: UINavigationController(),
                appConfigService: mockAppConfigService,
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

import CoreData

extension AppLaunchResponse {
    static var arrangeAvailable: AppLaunchResponse {
        .init(
            configResult: .success(.arrange),
            topicResult: .success(TopicResponseItem.arrangeMultiple)
        )
    }

    static var arrangeUnavailable: AppLaunchResponse {
        .init(
            configResult: .success(.arrange(config: .arrange(available: false))),
            topicResult: .success(TopicResponseItem.arrangeMultiple)
        )
    }
}
