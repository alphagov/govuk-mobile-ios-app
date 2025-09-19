import Foundation
import XCTest
import SwiftUI

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatActionViewControllerSnapshotTests: SnapshotTestCase {
    func test_warningText_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: WarningTestView(),
            mode: .light
        )
    }

    func test_warningText_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: WarningTestView(),
            mode: .dark
        )
    }

    func test_errorText_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: ErrorTestView(),
            mode: .light
        )
    }

    func test_errorText_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: ErrorTestView(),
            mode: .dark
        )
    }

    struct WarningTestView: View {
        @FocusState var textAreaFocused: Bool
        @State var showClearChatAlert: Bool = false

        var body: some View {
            let viewModel = ChatViewModel(
                chatService: MockChatService(),
                analyticsService: MockAnalyticsService(),
                openURLAction: { _ in },
                handleError: { _ in }
            )
            return ChatActionView(
                viewModel: viewModel,
                textAreaFocused: $textAreaFocused,
                showClearChatAlert: $showClearChatAlert,
                maxTextEditorFrameHeight: 640
            )
            .environment(\.isTesting, true)
            .onAppear {
                viewModel.warningText = LocalizedStringKey(
                    "Warning message"
                )
                textAreaFocused = true
            }
        }
    }

    struct ErrorTestView: View {
        @FocusState var textAreaFocused: Bool
        @State var showClearChatAlert: Bool = false

        var body: some View {
            let viewModel = ChatViewModel(
                chatService: MockChatService(),
                analyticsService: MockAnalyticsService(),
                openURLAction: { _ in },
                handleError: { _ in }
            )
            return ChatActionView(
                viewModel: viewModel,
                textAreaFocused: $textAreaFocused,
                showClearChatAlert: $showClearChatAlert,
                maxTextEditorFrameHeight: 640
            )
            .environment(\.isTesting, true)
            .onAppear {
                viewModel.errorText = LocalizedStringKey(
                    String.chat.localized("validationErrorText")
                )
                textAreaFocused = true
            }
        }
    }
}
