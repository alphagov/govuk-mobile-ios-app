import Foundation
import Onboarding
import GOVKit
import UIComponents

final class NotificationSettingsViewModel: ObservableObject {
    private let notificationService: NotificationServiceInterface
    private let completeAction: () -> Void
    private let primaryButtonTitle = String.notifications.localized("onboardingAcceptButtonTitle")
    private let analyticsService: AnalyticsServiceInterface
    let title = String.notifications.localized("onboardingTitle")
    @Published var state: State = .loading
    let primarybuttonAccessibilityHint = ""

    enum State {
        case loading
        case loaded(OnboardingSlideAnimationViewModel)
    }

    init(notificationService: NotificationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completeAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.completeAction = completeAction
        self.notificationService = notificationService
        fetchSlideInformation()
    }

    private func requestNotificationPermission() {
        notificationService.requestPermissions(
            completion: { [weak self] in
                self?.completeAction()
            }
        )
    }

    private func fetchSlideInformation() {
        notificationService.fetchSlides { [weak self] slideInformation in
            switch slideInformation {
            case .success(let slides):
                guard let slide = slides.first else {
                    self?.completeAction()
                    return
                }
                guard let animationSlide = slide as? OnboardingSlideAnimationViewModel
                else {
                    self?.completeAction()
                    return
                }
                DispatchQueue.main.async {
                    self?.state = .loaded(animationSlide)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.completeAction()
            }
        }
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        return .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                self?.requestNotificationPermission()
            }
        )
    }
}
