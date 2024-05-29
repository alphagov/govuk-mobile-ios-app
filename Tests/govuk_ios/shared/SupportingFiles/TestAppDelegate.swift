import UIKit

class TestAppDelegate: UIResponder, 
                       UIApplicationDelegate {
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = TestSceneDelegate.self
        sceneConfiguration.storyboard = nil

        return sceneConfiguration
    }
}
