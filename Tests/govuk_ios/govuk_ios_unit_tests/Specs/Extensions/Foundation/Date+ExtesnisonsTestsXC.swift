import Foundation
import XCTest

@testable import govuk_ios

final class Date_ExtensionsTestsXC: XCTestCase {

    func test_isToday_today_returnsTrue() {
        let sut = Date()
        XCTAssertTrue(sut.isToday())
    }

    func test_isToday_notToday_returnsFalse(dateString: String) {
        let dateStrings =  [
            "01/01/2001",
            "02/12/2004",
            "02/12/2024",
        ]
        for dateString in dateStrings {
            let sut = Date.arrange(dateString)
            XCTAssertFalse(sut.isToday())
        }
    }

    func test_isToday_notToday_inFuture_returnsFalse() {
        let sut = Date(timeIntervalSinceNow: 100000000)
        XCTAssertFalse(sut.isToday())
    }

    func test_isThisMonth_sameMonth_differentDay_returnsTrue() {
        let sut = Date.arrangeRandomDateFromThisMonthNotToday
        XCTAssertTrue(sut.isThisMonth())
    }

    func test_isThisMonth_sameMonth_differentYear_returnsFalse() {
        let calendar = Calendar.current
        var components = calendar.dateComponents(
            [.day, .month, .year, .hour, .minute, .second],
            from: Date()
        )
        components.year = 2022
        let sut = calendar.date(from: components)!
        XCTAssertFalse(sut.isThisMonth())
    }

    func test_isThisMonth_differentMonth_sameDay_returnsFalse() {
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: today)
        var months = Array(1...12)
        months.remove(at: month - 1)
        let modifiedDate = calendar.date(
            bySetting: .month,
            value: months.randomElement()!,
            of: today
        )!
        XCTAssertFalse(modifiedDate.isThisMonth())
    }

}
