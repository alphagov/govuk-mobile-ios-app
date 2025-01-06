import Foundation
import Testing
import GOVKitTestUtilities

@testable import RecentActivity

@Suite
struct MonthGroupKeyTests {

    @Test
    func init_withDate_setsValues() {
        let sut = MonthGroupKey(
            date: .arrange("01/03/2023")
        )
        #expect(sut.month == 3)
        #expect(sut.year == 2023)
        #expect(sut.title == "March 2023")
    }

    @Test(
        arguments: [
            "02/03/2000",
            "20/12/2002",
            "10/03/2020",
            "15/10/2022",
        ]
    )
    func greaterThan_largerDate_returnsTrue(dateString: String) {
        let sut = MonthGroupKey(
            date: .arrange(dateString)
        )
        let baseKey = MonthGroupKey(
            date: .arrange("01/02/2000")
        )
        #expect(sut > baseKey)
    }

    @Test
    func greaterThan_sameMonth_returnsFalse() {
        let sut = MonthGroupKey(
            date: .arrange("01/02/2000")
        )
        let baseKey = MonthGroupKey(
            date: .arrange("02/02/2000")
        )
        #expect((sut > baseKey) == false)
    }

    @Test(
        arguments: [
            "02/03/2000",
            "20/12/2002",
            "10/03/2020",
            "15/10/2022",
        ]
    )
    func lessThan_largerDate_returnsTrue(dateString: String) {
        let sut = MonthGroupKey(
            date: .arrange(dateString)
        )
        let baseKey = MonthGroupKey(
            date: .arrange("01/11/2022")
        )
        #expect(sut < baseKey)
    }

    @Test
    func lessThan_sameMonth_returnsFalse() {
        let sut = MonthGroupKey(
            date: .arrange("01/02/2000")
        )
        let baseKey = MonthGroupKey(
            date: .arrange("02/02/2000")
        )
        #expect((sut < baseKey) == false)
    }

}
