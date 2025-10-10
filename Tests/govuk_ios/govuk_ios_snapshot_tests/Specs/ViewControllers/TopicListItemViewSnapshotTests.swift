import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class TopicListItemViewSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
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
        let model = TopicListItemViewModel(
            topic: topic,
            tapAction: { }
        )
        let view = TopicListItemView(viewModel: model)
        return HostingViewController(rootView: view)
    }
}
