import UIKit
import GOVKit

@main
class AppDelegate: UIResponder,
                   UIApplicationDelegate {
    @Inject(\.analyticsService) private var analyticsService: AnalyticsServiceInterface
    @Inject(\.notificationService) private var notificationService: NotificationServiceInterface

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        analyticsService.launch()
        analyticsService.track(event: AppEvent.appLoaded)
        notificationService.appDidFinishLaunching(launchOptions: launchOptions)
        return true
    }
}
