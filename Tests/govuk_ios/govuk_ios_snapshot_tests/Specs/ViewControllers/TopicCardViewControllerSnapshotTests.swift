import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class TopicCardSnapshotTestst: SnapshotTestCase {
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
        let model = Topic(context: coreData.viewContext)
        model.title = "test"
        model.topicDescription = "test description"
        let view = TopicCard(model: model)
        return HostingViewController(rootView: view)
    }
}
