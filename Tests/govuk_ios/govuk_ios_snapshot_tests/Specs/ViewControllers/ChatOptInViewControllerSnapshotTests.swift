import Foundation
import SwiftUI

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatOptInViewControllerSnapshotTests: SnapshotTestCase {
    let viewControllerBuilder = ViewControllerBuilder()

    func test_loadInNavigationController_light_rendersCorrectly() {
        let chatOptInViewController = viewControllerBuilder.chatOptIn(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: chatOptInViewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let chatOptInViewController = viewControllerBuilder.chatOptIn(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: chatOptInViewController,
            mode: .dark
        )
    }
}

