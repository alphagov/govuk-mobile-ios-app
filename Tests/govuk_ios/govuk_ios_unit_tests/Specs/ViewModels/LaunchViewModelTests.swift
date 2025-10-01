import Foundation
import Testing

@testable import govuk_ios

struct LaunchViewModelTests {
    @Test
    func animationsCompleted_completed_returnsTrue() {
        let sut = LaunchViewModel(animationsCompletedAction: { })
        sut.crownAnimationCompleted = true
        sut.wordmarkAnimationCompleted = true

        #expect(sut.animationsCompleted)
    }

    @Test
    func animationsCompleted_incomplete_returnsFalse() {
        let sut = LaunchViewModel(animationsCompletedAction: { })
        sut.crownAnimationCompleted = true
        sut.wordmarkAnimationCompleted = false

        #expect(!sut.animationsCompleted)
    }
}
