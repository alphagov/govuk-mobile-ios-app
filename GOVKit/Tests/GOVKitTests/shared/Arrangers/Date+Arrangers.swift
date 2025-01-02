import Foundation

@testable import GOVKit

extension Date {
    static var arrange: Date {
        arrange()
    }

    static func arrange(_ string: String = "01/02/1993",
                        format: String = "dd/MM/yyyy") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    static var arrangeRandomDateFromThisMonth: Date {
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

    static var arrangeRandomDateFromThisMonthNotToday: Date {
        var date = Date.arrangeRandomDateFromThisMonth
        while date.isToday() {
            date = Date.arrangeRandomDateFromThisMonth
        }
        return date
    }

}
