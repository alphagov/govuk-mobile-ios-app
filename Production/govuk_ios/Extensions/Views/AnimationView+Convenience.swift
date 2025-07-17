import Foundation

extension AnimationView {
    static var launch: AnimationView {
        .init(
            resourceName: "app_splash",
            reducedAnimationProgress: 1
        )
    }
}
