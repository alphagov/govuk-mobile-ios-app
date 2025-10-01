import Foundation
import Testing

@testable import govuk_ios

struct LaunchViewModelTests {
    @Test
    func animationsCompleted_completed_callsAction() async {
        var completionCalled = false
        let sut = LaunchViewModel(
            animationsCompletedAction: { completionCalled = true }
        )
        sut.crownAnimationCompleted = true
        sut.wordmarkAnimationCompleted = true
        sut.animationsCompleted()

        #expect(completionCalled)
    }

    @Test
    func animationsCompleted_incomplete_doesntCallAction() {
        var completionCalled = false
        let sut = LaunchViewModel(
            animationsCompletedAction: { completionCalled = true }
        )
        sut.crownAnimationCompleted = true
        sut.wordmarkAnimationCompleted = false
        sut.animationsCompleted()

        #expect(!completionCalled)
    }
}
