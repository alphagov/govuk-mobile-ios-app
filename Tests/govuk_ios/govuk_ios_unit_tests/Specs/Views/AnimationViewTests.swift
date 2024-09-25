import Foundation
import XCTest
import Lottie
import Testing

import Factory

@testable import govuk_ios

@Suite(.serialized)
@MainActor
class AnimationViewTests {
    private var mockAccessibilityManager: MockAccessibilityManager!

    init() {
        mockAccessibilityManager = MockAccessibilityManager()
        Container.shared.lottieConfiguration.register {
            LottieConfiguration(renderingEngine: .mainThread)
        }
        Container.shared.accessibilityManager.register(
            factory: {
                self.mockAccessibilityManager
            }
        )
    }

    // This test isn't ideal, but there isn't much to assert against with Lottie
    @Test
    @MainActor
    func animationsEnabled_callsPlay() async {
        let subject = AnimationView(resourceName: "app_splash")

        mockAccessibilityManager.animationsEnabled = true

        var called = false
        subject.animateIfAvailable(
            completion: {
                called = true
            }
        )
        #expect(!called)
    }

    @Test
    @MainActor
    func animationsDisabled_delaysCompletion() async {
        let subject = AnimationView(resourceName: "app_splash")

        mockAccessibilityManager.animationsEnabled = false

        let called = await withCheckedContinuation { continuation in
            subject.animateIfAvailable(
                completion: {
                    continuation.resume(returning: true)
                }
            )
        }
        #expect(called == true)
    }
}
