import Foundation
import XCTest

@testable import govuk_ios

class HomeViewModelTests: XCTestCase {
    func test_widgets_returnsArrayOfWidgets() {
        let subject = HomeViewModel()
        let widgets = subject.widgets

        XCTAssert((widgets as Any) is [HomeWidgetViewModel])
    }
}
