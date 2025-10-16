import Foundation
import UIKit
import Authentication

protocol AppAuthSessionWrapperInterface {
    @MainActor
    func session(window: UIWindow) -> LoginSession
}

class AppAuthSessionWrapper: AppAuthSessionWrapperInterface {
    @MainActor
    func session(window: UIWindow) -> LoginSession {
        AppAuthSessionV2(window: window)
    }
}
