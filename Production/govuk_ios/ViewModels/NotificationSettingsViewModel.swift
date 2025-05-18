import Foundation
import Onboarding
import GOVKit
import UIComponents

final class NotificationSettingsViewModel: ObservableObject {
    private let notificationService: NotificationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let userDefaults: UserDefaultsInterface
    private let completeAction: () -> Void

    let slide: OnboardingSlideAnimationViewModel = Onboarding.notificationSlide
    var primaryButtonTitle: String { slide.primaryButtonTitle }
    var primarybuttonAccessibilityHint: String? { slide.primaryButtonAccessibilityHint }

    init(notificationService: NotificationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaults: UserDefaultsInterface = UserDefaults.standard,
         completeAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completeAction = completeAction
        self.userDefaults = userDefaults
        self.notificationService = notificationService
    }

    private func requestNotificationPermission() {
        notificationService.requestPermissions(
            completion: completeAction
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.requestNotificationPermission()
            }
        )
    }
}
