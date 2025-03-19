import UIKit

public protocol AnalyticsServiceInterface {
    func launch()
    func track(event: AppEvent)
    func track(screen: TrackableScreen)
    func set(userProperty: UserProperty)

    func setAcceptedAnalytics(accepted: Bool)
    var permissionState: AnalyticsPermissionState { get }
}
