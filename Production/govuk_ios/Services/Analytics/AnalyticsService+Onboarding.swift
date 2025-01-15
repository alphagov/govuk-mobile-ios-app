import Foundation

import GOVKit
import Onboarding

extension AnalyticsService: OnboardingAnalyticsService {
    func trackOnboardingEvent(_ event: OnboardingEvent) {
        let eventParams: [String: Any] = event.additionalParams?.compactMapValues({ $0 }) ?? [:]
        let mergedParams = eventParams.merging(
            [
                "type": event.type,
                "text": event.text,
                "language": Locale.current.analyticsLanguageCode
            ].compactMapValues({ $0 }),
            uniquingKeysWith: { lhs, _ in lhs }
        )
        let mappedEvent = AppEvent(
            name: event.name,
            params: mergedParams
        )
        track(event: mappedEvent)
    }

    func trackOnboardingScreen(_ screen: OnboardingScreen) {
        track(screen: screen)
    }
}

extension OnboardingScreen: TrackableScreen { }
