import UIKit
import GAnalytics
import Logging

class AppDelegate: UIResponder,
                   UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        GAnalytics().configure()
        GovukAnalyticsService(analytics: GAnalytics() as AnalyticsService).logDeviceInformation()
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
