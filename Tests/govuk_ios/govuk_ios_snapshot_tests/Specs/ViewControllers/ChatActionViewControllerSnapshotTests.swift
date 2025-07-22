import Foundation
import XCTest
import SwiftUI

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatActionViewControllerSnapshotTests: SnapshotTestCase {
    @FocusState var textAreaFocused: Bool

    func test_remainingCharacters_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: RemainingCharactersTestView(),
            mode: .light
        )
    }

    func test_remainingCharacters_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: RemainingCharactersTestView(),
            mode: .dark
        )
    }

    func test_tooManyCharacters_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: TooManyCharactersTestView(),
            mode: .light
        )
    }

    func test_tooManyCharacters_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: TooManyCharactersTestView(),
            mode: .dark
        )
    }
}

struct RemainingCharactersTestView: View {
    @FocusState var textAreaFocused: Bool

    var body: some View {
        let viewModel = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: MockAnalyticsService()
        )

        ChatActionView(
            viewModel: viewModel,
            textAreaFocused: $textAreaFocused
        )
        .environment(\.isTesting, true)
        .onAppear {
            viewModel.latestQuestion = """
              Lorem ipsum dolor sit amet consectetur adipiscing
              elit quisque faucibus ex sapien vitae pellentesque 
              sem placerat in id cursus mi pretium tellus duis 
              convallis tempus leo eu aenean sed diam urna tempor 
              pulvinar vivamus fringillsss lacus nec metus biben
              """
            textAreaFocused = true
        }
    }
}

struct TooManyCharactersTestView: View {
    @FocusState var textAreaFocused: Bool

    var body: some View {
        let viewModel = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: MockAnalyticsService()
        )

        ChatActionView(
            viewModel: viewModel,
            textAreaFocused: $textAreaFocused
        )
        .environment(\.isTesting, true)
        .onAppear {
            viewModel.latestQuestion = """
                  Lorem ipsum dolor sit amet consectetur adipiscing
                  elit quisque faucibus ex sapien vitae pellentesque 
                  sem placerat in id cursus mi pretium tellus duis 
                  convallis tempus leo eu aenean sed diam urna tempor 
                  pulvinar vivamus fringillsss lacus nec metus biben
                  pulvinar vivamus fringillsss lacus nec metus biben
                  pulvinar vivamus fringillsss lacus nec metus biben
                  """
            textAreaFocused = true
        }
    }
}
