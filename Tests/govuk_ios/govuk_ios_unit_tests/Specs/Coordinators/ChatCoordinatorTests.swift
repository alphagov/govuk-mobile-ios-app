import Foundation
import UIKit
import GOVKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct ChatCoordinatorTests {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_setsChatViewController() throws {
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let navigationController = UINavigationController()
        let sut = ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            deepLinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            configService: MockAppConfigService()
        )

        sut.start()
        let firstViewController = navigationController.viewControllers.first
        _ = try #require(firstViewController as? HostingViewController<ChatView>)
    }
}
