import Foundation

class LaunchViewModel {
    private let animationsCompletedAction: () -> Void
    var crownAnimationCompleted = false
    var wordmarkAnimationCompleted = false

    init(animationsCompletedAction: @escaping () -> Void) {
        self.animationsCompletedAction = animationsCompletedAction
    }

    func animationsCompleted() {
        if crownAnimationCompleted && wordmarkAnimationCompleted {
            animationsCompletedAction()
        }
    }
}
