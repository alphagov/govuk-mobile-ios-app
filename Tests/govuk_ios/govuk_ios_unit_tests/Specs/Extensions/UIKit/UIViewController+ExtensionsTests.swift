import Foundation

import XCTest

@testable import govuk_ios

class UIViewController_ExtensionsTests: XCTestCase {
    func test_viewWillReAppear_animated_callsTransitions() {
        let subject = MockBaseViewController()
        subject.viewWillReAppear(
            isAppearing: true,
            animated: false
        )

        XCTAssertEqual(subject._receivedBeginAppearanceTransitionAnimated, false)
        XCTAssertTrue(subject._endAppearanceTransitionCalled)
    }
}
