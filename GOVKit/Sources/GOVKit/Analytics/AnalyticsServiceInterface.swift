import UIKit

public protocol AnalyticsServiceInterface {
    func launch()
    func track(event: AppEvent)
    func track(screen: TrackableScreen)
    func track(error: Error)
    func set(userProperty: UserProperty)
    func resetConsent()

    func setAcceptedAnalytics(accepted: Bool)
    func setExistingConsent()
    var permissionState: AnalyticsPermissionState { get }
}
