import Foundation

class LaunchViewModel {
    let animationsCompletedAction: () -> Void
    var crownAnimationCompleted = false
    var wordmarkAnimationCompleted = false

    init(animationsCompletedAction: @escaping () -> Void) {
        self.animationsCompletedAction = animationsCompletedAction
    }

    var animationsCompleted: Bool {
        crownAnimationCompleted && wordmarkAnimationCompleted
    }
}
