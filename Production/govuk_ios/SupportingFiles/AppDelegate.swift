import UIKit
import GOVKit

@main
class AppDelegate: UIResponder,
                   UIApplicationDelegate {
    @Inject(\.analyticsService) private var analyticsService: AnalyticsServiceInterface

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        analyticsService.launch()
        analyticsService.track(event: AppEvent.appLoaded)
        return true
    }
}
