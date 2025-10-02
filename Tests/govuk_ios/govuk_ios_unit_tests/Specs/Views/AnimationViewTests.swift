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
    func animationsEnabled_callsPlay() {
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

    @Test
    @MainActor
    func hasAnimationBegun_animationStopped_returnsFalse() {
        let subject = AnimationView(
            resourceName: "app_splash",
            reducedAnimationProgress: 0
        )

        #expect(!subject.hasAnimationBegun)
    }

    @Test
    @MainActor
    func hasAnimationBegun_updatedProgress_returnsFalse() {
        let subject = AnimationView(
            resourceName: "app_crown_splash",
            reducedAnimationProgress: 0.5
        )

        mockAccessibilityManager.animationsEnabled = false

        subject.animateIfAvailable { /* Do nothing */ }

        #expect(subject.hasAnimationBegun)
    }

    @Test
    @MainActor
    func hasAnimationBegun_animationStarted_returnsTrue() {
        let subject = AnimationView(resourceName: "app_crown_splash")
        subject.animateIfAvailable { /* Do nothing */ }

        #expect(subject.hasAnimationBegun)
    }
}
