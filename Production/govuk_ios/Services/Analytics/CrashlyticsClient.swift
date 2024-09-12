import Foundation

import FirebaseCrashlytics

struct CrashlyticsClient: AnalyticsClient {
    private let crashlytics: Crashlytics

    init(crashlytics: Crashlytics) {
        self.crashlytics = crashlytics
    }

    func launch() {
        /*Do nothing*/
    }

    func setEnabled(enabled: Bool) {
        crashlytics.setCrashlyticsCollectionEnabled(enabled)
    }

    func track(screen: any TrackableScreen) {
        /*Do nothing*/
    }

    func track(event: AppEvent) {
        /*Do nothing*/
    }
}
