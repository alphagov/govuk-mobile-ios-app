import Foundation

extension Date {
    func isToday(calendar: Calendar = .current) -> Bool {
        calendar.isDateInToday(self)
    }

    func isThisMonth(calendar: Calendar = .current) -> Bool {
        calendar.isDate(
            self,
            equalTo: Date(),
            toGranularity: .month
        )
    }
}
