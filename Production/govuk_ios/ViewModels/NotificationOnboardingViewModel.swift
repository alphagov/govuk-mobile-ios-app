import Foundation
import UIComponents

struct NotificationOnboardingViewModel: OnboardingViewModel {
    var animationName: String
    let title: String = String.notifications.localized("onboardingTitle")
    let body: String = String.notifications.localized("onboardingBody")
    var primaryButtonViewModel: GOVUKButton.ButtonViewModel
    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel
}
