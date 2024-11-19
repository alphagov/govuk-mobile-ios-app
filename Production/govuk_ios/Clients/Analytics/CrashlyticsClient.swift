import Foundation

import FirebaseCrashlytics

struct CrashlyticsClient: AnalyticsClient {
    private let crashlytics: CrashlyticsInterface

    init(crashlytics: CrashlyticsInterface) {
        self.crashlytics = crashlytics
    }

    func setEnabled(enabled: Bool) {
        crashlytics.setCrashlyticsCollectionEnabled(enabled)
    }

    func launch() { /*Do nothing*/ }

    func track(screen: any TrackableScreen) { /*Do nothing*/ }

    func track(event: AppEvent) { /*Do nothing*/ }

    func setUserProperty(key: String, value: String) { /*Do nothing*/ }
}

protocol CrashlyticsInterface {
    func setCrashlyticsCollectionEnabled(_ newValue: Bool)
}

extension Crashlytics: CrashlyticsInterface { }
