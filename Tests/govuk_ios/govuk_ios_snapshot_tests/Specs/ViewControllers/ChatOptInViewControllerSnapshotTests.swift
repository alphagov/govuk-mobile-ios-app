import Foundation
import SwiftUI

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatOptInViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = ChatOptInViewModel(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            completionAction: { }
        )
        let chatOptInView = InfoView(viewModel: viewModel) {
            AnyView(InfoLinksView(
                linkList: [
                    LinkListItem(
                        text: "Test link",
                        url: URL(string: "www.gov.uk")!
                    ),
                    LinkListItem(
                        text: "Test link two",
                        url: URL(string: "www.gov.uk")!
                    )
                ],
                openURLAction: { _ in }
            ))
        }

        VerifySnapshotInNavigationController(
            view: chatOptInView,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = ChatOptInViewModel(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            completionAction: { }
        )
        let chatOptInView = InfoView(viewModel: viewModel) {
            AnyView(InfoLinksView(
                linkList: [
                    LinkListItem(
                        text: "Test link",
                        url: URL(string: "www.gov.uk")!
                    ),
                    LinkListItem(
                        text: "Test link two",
                        url: URL(string: "www.gov.uk")!
                    )
                ],
                openURLAction: { _ in }
            ))
        }

        VerifySnapshotInNavigationController(
            view: chatOptInView,
            mode: .dark
        )
    }
}

