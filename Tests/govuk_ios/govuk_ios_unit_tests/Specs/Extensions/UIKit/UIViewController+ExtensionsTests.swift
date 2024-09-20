import Foundation

import Testing

@testable import govuk_ios

@MainActor
@Suite
struct UIViewController_ExtensionsTests {

    @Test
    func viewWillReAppear_animated_callsTransitions() {
        let subject = MockBaseViewController()
        subject.viewWillReAppear(
            isAppearing: true,
            animated: false
        )

        #expect(subject._receivedBeginAppearanceTransitionAnimated == false)
        #expect(subject._endAppearanceTransitionCalled)
    }
}
