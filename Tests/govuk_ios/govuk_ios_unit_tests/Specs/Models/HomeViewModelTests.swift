import Foundation
import XCTest

@testable import govuk_ios

class HomeViewModelTests: XCTestCase {
    func test_widgets_returnsArrayOfWidgets() {
        let subject = HomeViewModel(
            configService: MockAppConfigService(), 
            searchButtonPrimaryAction: { },
            recentActivityAction: {}
        )
        let widgets = subject.widgets

        XCTAssert((widgets as Any) is [WidgetView])
        XCTAssertEqual(widgets.count, 1)
    }

    func test_widgets_featureDisabled_doesntReturnWidget() {
        let configService = MockAppConfigService()
        configService.features = []

        let subject = HomeViewModel(
            configService: configService,
            searchButtonPrimaryAction: { },
            recentActivityAction: {}
        )
        let widgets = subject.widgets

        XCTAssertEqual(widgets.count, 0)
    }
}
