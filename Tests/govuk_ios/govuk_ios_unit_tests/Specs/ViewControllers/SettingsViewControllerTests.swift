import Foundation
import UIKit
import SwiftUI
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct SettingsViewControllerTests {
    @Test
    func settings_hasCorrectBackgroundColor() {
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            bundle: .main
        )
        let subject = SettingsViewController(viewModel: viewModel)
        let view = subject.view
        #expect(view?.backgroundColor == UIColor.govUK.fills.surfaceBackground)
        #expect(subject.title == "Settings")
    }

    @Test
    func groupedList_hasCorrectBackgroundColor() throws {
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            bundle: .main
        )
        let subject = SettingsViewController(viewModel: viewModel)
        subject.beginAppearanceTransition(true, animated: false)
        subject.endAppearanceTransition()
        let hostingController = try #require(subject.children.first as? UIHostingController<GroupedList>)
        #expect(hostingController.rootView.backgroundColor == UIColor.govUK.fills.surfaceBackground)
    }
}
