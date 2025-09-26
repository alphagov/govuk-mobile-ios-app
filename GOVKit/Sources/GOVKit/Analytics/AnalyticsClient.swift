import Foundation

public protocol AnalyticsClient {
    func launch()
    func setEnabled(enabled: Bool)
    func track(screen: TrackableScreen)
    func track(event: AppEvent)
    func track(error: Error)
    func set(userProperty: UserProperty)
}
