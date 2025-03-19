import Foundation

import Factory
import Lottie

extension Container {
    var lottieConfiguration: Factory<LottieConfiguration> {
        Factory(self) {
            LottieConfiguration.shared
        }
    }

    var accessibilityManager: Factory<AccessibilityManagerInterface> {
        Factory(self) {
            AccessibilityManager()
        }
    }
}
