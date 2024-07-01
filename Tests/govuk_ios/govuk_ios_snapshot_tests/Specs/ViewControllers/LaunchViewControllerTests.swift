import Foundation
import XCTest
import UIKit

import Factory
import Lottie

@testable import govuk_ios

class LaunchViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {

        Container.shared.lottieConfiguration.register { LottieConfiguration(renderingEngine: .mainThread) }

        let viewModel = LaunchViewModel(
            animationCompleted: {

            }
        )
        let subject = LaunchViewController(
            viewModel: viewModel
        )
        VerifySnapshotInWindow(subject)
    }
}
