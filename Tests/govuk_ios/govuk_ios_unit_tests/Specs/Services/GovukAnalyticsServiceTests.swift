import UIKit
import Foundation
import XCTest

@testable import govuk_ios

final class GovukAnalyticsServiceTests: XCTestCase {
    func test_logDeviceInformation_logsEvents() {
        let analytics = MockAnalyticsService()
        let subject = GovukAnalyticsService(analytics: analytics)

        subject.logDeviceInformation()
       
        XCTAssertTrue(analytics.eventsParamsLogged.count == 4)
        XCTAssertEqual(analytics.eventsParamsLogged["system_name"], "iOS")
    }
}
