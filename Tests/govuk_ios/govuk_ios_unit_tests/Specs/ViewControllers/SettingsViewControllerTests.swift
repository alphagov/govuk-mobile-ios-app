import UIKit
import SwiftUI
import Foundation
import XCTest

@testable import govuk_ios

@MainActor
class SettingsViewControllerTests: XCTestCase {
    func test_settings_hasCorrectBackgroundColor() {
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            bundle: .main
        )
        let subject = SettingsViewController(viewModel: viewModel)
        let view = subject.view
        XCTAssertEqual(view?.backgroundColor, UIColor.govUK.fills.surfaceBackground)
        XCTAssertEqual(subject.title, "Settings")
    }

    func test_groupedList_hasCorrectBackgroundColor() throws {
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            bundle: .main
        )
        let subject = SettingsViewController(viewModel: viewModel)
        subject.beginAppearanceTransition(true, animated: false)
        subject.endAppearanceTransition()
        let hostingController = try XCTUnwrap(subject.children.first as? UIHostingController<GroupedList>)
        XCTAssertEqual(hostingController.rootView.backgroundColor, UIColor.govUK.fills.surfaceBackground)
    }
}
