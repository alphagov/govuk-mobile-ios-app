import Foundation

import Onboarding

extension AnalyticsService: OnboardingAnalyticsService {
    func trackOnboardingEvent(_ event: OnboardingEvent) {
        let mappedEvent = AppEvent(
            name: event.name,
            params: event.params
        )
        track(event: mappedEvent)
    }

    func trackOnboardingScreen(_ screen: OnboardingScreen) {
        track(screen: screen)
    }
}

extension OnboardingScreen: TrackableScreen {}
