import XCTest

final class GovUKUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()


        let label = app.images["logo"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
