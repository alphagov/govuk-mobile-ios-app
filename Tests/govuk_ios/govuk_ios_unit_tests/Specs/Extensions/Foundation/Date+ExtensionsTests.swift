import Foundation
import Testing
@testable import GOVKitTestUtilities

@testable import govuk_ios

@Suite
struct Date_ExtensionsTests {
    @Test
    func isToday_today_returnsTrue() {
        let sut = Date()
        #expect(sut.isToday())
    }

    @Test(
        arguments: [
            "01/01/2001",
            "02/12/2004",
            "02/12/2025",
        ]
    )
    func isToday_notToday_returnsFalse(dateString: String) {
        let sut = Date.arrange(dateString)
        #expect(!sut.isToday())
    }

    @Test
    func isToday_notToday_inFuture_returnsFalse() {
        let sut = Date(timeIntervalSinceNow: 100000000)
        #expect(!sut.isToday())
    }

    @Test
    func isThisMonth_sameMonth_differentDay_returnsTrue() {
        let sut = Date.arrangeRandomDateFromThisMonthNotToday
        #expect(sut.isThisMonth())
    }

    @Test
    func isThisMonth_sameMonth_differentYear_returnsFalse() {
        let calendar = Calendar.current
        var components = calendar.dateComponents(
            [.day, .month, .year, .hour, .minute, .second],
            from: Date()
        )
        components.year = 2022
        let sut = calendar.date(from: components)!
        #expect(!sut.isThisMonth())
    }

    @Test
    func isThisMonth_differentMonth_sameDay_returnsFalse() {
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
        #expect(!modifiedDate.isThisMonth())
    }
}
