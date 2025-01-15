import Foundation

@testable import GOVKit

extension Date {
    public static var arrangeRandomDateFromThisMonth: Date {
        let date = Date()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: date
        )
        let days = calendar.range(of: .day, in: .month, for: date)!

        let randomDay = days.randomElement()!

        dateComponents.setValue(randomDay, for: .day)
        return calendar.date(from: dateComponents)!
    }

    public static var arrangeRandomDateFromThisMonthNotToday: Date {
        var date = Date.arrangeRandomDateFromThisMonth
        while date.isToday() {
            date = Date.arrangeRandomDateFromThisMonth
        }
        return date
    }

}
