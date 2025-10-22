import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class TopicWidgetViewControllerSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad

    func test_loadInNavigationController_light_rendersCorrectly() {
        let sut = viewController()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController() -> UIViewController {
        let topic = Topic(context: coreData.viewContext)
        topic.title = "Benefits"
        topic.ref = "benefits"
        topic.topicDescription = "test description"
        let viewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(), analyticsService: MockAnalyticsService(),
            topicAction: { _ in }
        )
        viewModel.topicsToBeDisplayed = [topic]
        let view = TopicsWidget(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}

