import Foundation
import XCTest

import Factory

@testable import govuk_ios

class AnimationViewTests: XCTestCase {
    private var mockAccessibilityManager: MockAccessibilityManager!

    override func setUp() {
        mockAccessibilityManager = MockAccessibilityManager()
        Container.shared.accessibilityManager.register(
            factory: {
                self.mockAccessibilityManager
            }
        )
    }

    func test_animationsDisabled_delaysCompletion() {
        let subject = AnimationView(resourceName: "app_splash")

        mockAccessibilityManager.animationsEnabled = false

        let expectation = expectation(description: "animation expectation")
        subject.animateIfAvailable(
            completion: {
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 2.2)
    }

}
