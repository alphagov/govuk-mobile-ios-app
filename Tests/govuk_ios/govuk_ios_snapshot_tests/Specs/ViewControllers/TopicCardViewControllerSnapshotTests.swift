import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class TopicCardViewControllerSnapshotTests: SnapshotTestCase {
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
        let context = coreData.viewContext
        let topic = Topic.arrange(context: context, isFavourite: false)
        let view = TopicCard(model: topic)
        return HostingViewController(rootView: view)
    }
}

