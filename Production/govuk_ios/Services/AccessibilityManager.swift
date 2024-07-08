import Foundation
import UIKit

protocol AccessibilityManagerInterface {
    var animationsEnabled: Bool { get }
}

struct AccessibilityManager: AccessibilityManagerInterface {
    var animationsEnabled: Bool {
        UIView.areAnimationsEnabled &&
        !UIAccessibility.isReduceMotionEnabled
    }
}
