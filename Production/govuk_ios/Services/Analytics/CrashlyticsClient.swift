import Foundation

import FirebaseCrashlytics

struct CrashlyticsClient: AnalyticsClient {
    func launch() {}

    func setEnabled(enabled: Bool) {
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(enabled)
    }

    func track(screen: any TrackableScreen) {}

    func track(event: AppEvent) {}
}
