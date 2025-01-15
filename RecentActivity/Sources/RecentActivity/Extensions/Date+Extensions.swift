import Foundation

extension Date {
    public func isToday(calendar: Calendar = .current) -> Bool {
        calendar.isDateInToday(self)
    }

    public func isThisMonth(calendar: Calendar = .current) -> Bool {
        calendar.isDate(
            self,
            equalTo: Date(),
            toGranularity: .month
        )
    }
}
