import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
class PrivacyCoordinatorTests {
    @Test
    func privacyCoordinator_start_setsPrivacyView() {
        let sut = PrivacyCoordinator(
            navigationController: UINavigationController()
        )
        sut.start()

        #expect(sut.root.topViewController is HostingViewController<PrivacyView>)
    }
}
