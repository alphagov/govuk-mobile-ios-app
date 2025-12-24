import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios

@MainActor
final class ChatWidgetViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark
        )
    }

    private func viewController() -> UIViewController {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService._stubbedChatBanner = .init(
            id: "1234",
            title: "title",
            body: "body",
            link: ChatBanner.Link(title: "link", url: URL(string: "www.test.com")!)
        )
        let viewModel = ChatWidgetViewModel(
            analyticsService: MockAnalyticsService(),
            chat: mockAppConfigService._stubbedChatBanner!,
            urlOpener: MockURLOpener(),
            dismiss: {}
        )
        let view = ChatWidgetView(viewModel: viewModel)
        return HostingViewController(rootView: view)
    }
}
