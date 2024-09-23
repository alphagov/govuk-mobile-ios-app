import XCTest
@testable import govuk_ios

final class DateHelperTests: XCTestCase {

    func test_getDay_returnsCorrectDayNumber() throws {
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let mockDate = dateFormatter.date(from:isoDate)!

        var date = DateHelper.getDay(date: mockDate)

        XCTAssertEqual(date, 14)
    }

    func test_getMonthName_returnsCorrectDateString() throws {
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let mockDate = dateFormatter.date(from:isoDate)!
        var date = DateHelper.getDay(date: mockDate)
        let components = DateHelper.returnCalanderComponent(date: mockDate)

        let month = DateHelper.getMonthName(components: components)

        XCTAssertEqual(month, "April")
    }

    func test_checkDatesAreTheSame_whenDatesAreTheSame_returnsTrue() throws {
        let dateOne = Date()
        let dateTwo = Date()

        let dateEquality = DateHelper.checkDatesAreTheSame(
            dateOne: dateOne,
            dateTwo: dateTwo
        )

        XCTAssertTrue(dateEquality)
    }

    func test_checkEqualityOfMonthAndYear_whenMonthAndYearAreEqual_returnsTrue() throws {
        let dateOne = Date()
        let dateTwo = Date()

        let dateEquality = DateHelper.checkEqualityOfMonthAndYear(
            dateOne: dateOne,
            dateTwo: dateTwo
        )

        XCTAssertTrue(dateEquality)
    }

    func test_getMonthAndYear_returnsCorrectString() throws {
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let mockDate = dateFormatter.date(from: isoDate)!

        var dateString = DateHelper.getMonthAndYear(date: mockDate)

        XCTAssertEqual(dateString, "April 2016")
    }
}

