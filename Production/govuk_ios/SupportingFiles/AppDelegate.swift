import UIKit

class AppDelegate: UIResponder,
                   UIApplicationDelegate {
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
