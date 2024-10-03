import Foundation
import XCTest

@testable import govuk_ios

final class MonthGroupKeyTestsXC: XCTestCase {

    
    func test_init_withDate_setsValues() {
        let sut = MonthGroupKey(
            date: .arrange("01/03/2023")
        )
        XCTAssertTrue(sut.month == 3)
        XCTAssertTrue(sut.year == 2023)
        XCTAssertTrue(sut.title == "March 2023")
    }

    func test_greaterThan_largerDate_returnsTrue(dateString: String) {
        let dateStrings = [
            "02/03/2000",
            "20/12/2002",
            "10/03/2020",
            "15/10/2022",
        ]
        for dateString in dateStrings {
            let sut = MonthGroupKey(
                date: .arrange(dateString)
            )
            let baseKey = MonthGroupKey(
                date: .arrange("01/02/2000")
            )
            XCTAssertTrue(sut > baseKey)
        }
    }

    func test_greaterThan_sameMonth_returnsFalse() {
        let sut = MonthGroupKey(
            date: .arrange("01/02/2000")
        )
        let baseKey = MonthGroupKey(
            date: .arrange("02/02/2000")
        )
        XCTAssertTrue((sut > baseKey) == false)
    }
    
    func test_lessThan_largerDate_returnsTrue(dateString: String) {
        let dateStrings = [
            "02/03/2000",
            "20/12/2002",
            "10/03/2020",
            "15/10/2022",
        ]
        for dateString in dateStrings {
            let sut = MonthGroupKey(
                date: .arrange(dateString)
            )
            let baseKey = MonthGroupKey(
                date: .arrange("01/11/2022")
            )
            XCTAssertTrue(sut < baseKey)
        }
    }
    
    func test_lessThan_sameMonth_returnsFalse() {
        let sut = MonthGroupKey(
            date: .arrange("01/02/2000")
        )
        let baseKey = MonthGroupKey(
            date: .arrange("02/02/2000")
        )
        XCTAssertTrue((sut < baseKey) == false)
    }
}
