import XCTest

@testable import govuk_ios

final class DateHelperTests: XCTestCase {
    func test_checkDatesAreTheSame_whenDatesAreTheSame_returnsTrue() {
        let dateOne = Date.arrange("01/01/2005")
        let dateTwo = Date.arrange("01/01/2005")

        let dateEquality = DateHelper.checkDatesAreTheSameDay(
            dateOne: dateOne,
            dateTwo: dateTwo
        )

        XCTAssertTrue(dateEquality)
    }

    func test_checkDatesAreTheSame_differentDays_returnsFalse() {
        let dateOne = Date.arrange("01/02/2003")
        let dateTwo = Date.arrange("02/02/2003")

        let dateEquality = DateHelper.checkDatesAreTheSameDay(
            dateOne: dateOne,
            dateTwo: dateTwo
        )

        XCTAssertFalse(dateEquality)
    }

    func test_checkEqualityOfMonthAndYear_whenMonthAndYearAreEqual_returnsTrue() {
        let dateOne = Date()
        let dateTwo = Date()

        let dateEquality = DateHelper.checkEqualityOfMonthAndYear(
            dateOne: dateOne,
            dateTwo: dateTwo
        )

        XCTAssertTrue(dateEquality)
    }

    func test_getMonthAndYear_returnsCorrectString() {
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let mockDate = dateFormatter.date(from: isoDate)!

        var dateString = DateHelper.getMonthAndYear(date: mockDate)

        XCTAssertEqual(dateString, "April 2016")
    }
}

