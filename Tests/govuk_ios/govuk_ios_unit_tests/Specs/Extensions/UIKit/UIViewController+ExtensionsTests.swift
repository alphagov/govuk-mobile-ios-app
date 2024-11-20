import Foundation

import Testing

@testable import govuk_ios

@Suite
@MainActor
struct UIViewController_ExtensionsTests {

    @Test
    @MainActor
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
