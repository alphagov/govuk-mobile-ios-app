import Foundation
import XCTest
import UIKit
import GOVKit
import Combine
import Onboarding

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class NotificationSettingsViewControllerSnapshotTests: SnapshotTestCase {
    var cancellables = Set<AnyCancellable>()
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockNotificationService = MockNotificationService()

        let viewModel = NotificationSettingsViewModel(
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            completeAction: {}
        )
        let subject = NotificationSettingsView(
            viewModel: viewModel,
            analyticsService: MockAnalyticsService()
        )
        let hostingViewController = HostingViewController(
            rootView: subject
        )
        let expectation = expectation(description: "sdf")
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
            guard case .loaded = value else { return }
            self?.RecordSnapshotInNavigationController(
                viewController: hostingViewController,
                mode: .light,
                prefersLargeTitles: false
            )
            expectation.fulfill()
        }.store(in: &cancellables)
        mockNotificationService._receivedFetchSlidesCompletion?(
            .success(
                [
                    OnboardingSlideImageViewModel(
                        slide: .init(image: "", title: "testwerwer", body: "dsvsdfds", name: "sdfsdf"),
                        primaryButtonTitle: "Test2234",
                        primaryButtonAccessibilityHint: nil,
                        secondaryButtonTitle: "",
                        secondaryButtonAccessibilityHint: nil
                    )
                ]
            )
        )
        wait(for: [expectation])
    }
}
