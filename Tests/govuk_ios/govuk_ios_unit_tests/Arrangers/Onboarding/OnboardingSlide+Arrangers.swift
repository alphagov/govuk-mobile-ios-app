import Foundation

import Onboarding

extension OnboardingSlide {
    static var arrange: OnboardingSlide {
        .init(
            image: "1231",
            title: "312",
            body: "123"
        )
    }

    static func arrange(_ count: Int) -> [OnboardingSlide] {
        (0...count).map { _ in
            OnboardingSlide.arrange
        }
    }
}
