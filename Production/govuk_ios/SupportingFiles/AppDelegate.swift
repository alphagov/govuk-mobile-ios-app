import UIKit

class AppDelegate: UIResponder,
                   UIApplicationDelegate {
    @Inject(\.analyticsService) private var analyticsService: AnalyticsServiceInterface

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        analyticsService.configure()
        analyticsService.setAcceptedAnalytics(accepted: true)
        analyticsService.track(event: AppEvent.appLoaded)

        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = AppSceneDelegate.self
        sceneConfiguration.storyboard = nil

        return sceneConfiguration
    }
}
