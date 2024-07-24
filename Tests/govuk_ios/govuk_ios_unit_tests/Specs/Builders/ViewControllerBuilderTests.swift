import Foundation
import XCTest

@testable import govuk_ios

class ViewControllerBuilderTests: XCTestCase {
    func test_red_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.red(
            showNextAction: {},
            showModalAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Red")
    }

    func test_blue_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.blue(
            showNextAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Blue")
    }

    func test_driving_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.driving(
            showPermitAction: {},
            presentPermitAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Driving")
    }

    func test_permit_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.permit(
            permitId: "123",
            finishAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Permit - 123")
    }

    func test_home_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.home()

        XCTAssert(result is HomeViewController)
    }

    func test_settings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.settings()

        XCTAssert(result is SettingsViewController)
    }
}
