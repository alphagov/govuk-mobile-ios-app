import GDSCommon
@testable import govuk_ios
import SwiftUI
import XCTest

final class ButtonWrapperTests: XCTestCase {
    var sut: (any View)!

    override func setUp() {
        super.setUp()
        
        sut = ButtonWrapper<SecondaryButton>(title: "test button") {
            // some action here
        }
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func test_buttonCreated() {
        guard let button = sut as? ButtonWrapper<SecondaryButton> else {
            XCTFail("button test failed")
            return
        }

        XCTAssertNotNil(button)
    }

    func test_buttonCreatedWithIcon() {
        sut = ButtonWrapper<SecondaryButton>(title: "test button", icon: "arrow.up.right") {
            // some action here
        }

        guard let button = sut as? ButtonWrapper<SecondaryButton> else {
            XCTFail("button test failed")
            return
        }

        XCTAssertNotNil(button)
    }
}
