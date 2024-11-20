import Foundation

protocol AnalyticsClient {
    func launch()
    func setEnabled(enabled: Bool)
    func track(screen: TrackableScreen)
    func track(event: AppEvent)
    func set(userProperty: UserProperty)
}
