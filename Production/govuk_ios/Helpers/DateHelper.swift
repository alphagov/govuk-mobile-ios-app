import Foundation

class DateHelper {
    static func getDay(date: Date) -> Int? {
        let component = returnCalanderComponent(date: date)
        guard let day = component.day else { return nil }
        return day
    }

    static func getMonthName(components: DateComponents) -> String {
        guard let componentMonth = components.month else { return "" }
        return DateFormatter().monthSymbols[componentMonth - 1]
    }

    static func getMonthAndYear(date: Date) -> String {
        let components = returnCalanderComponent(date: date)
        let monthName = getMonthName(components: components)
        guard let year = components.year else { return "" }
        return "\(monthName) \(year)"
    }

    static func isSameDayAs(dateOne: Date, dateTwo: Date) -> Bool {
        let dayEquality = Calendar.current.isDate(
            dateOne,
            equalTo: dateTwo,
            toGranularity: Calendar.Component.day
        )
        return dayEquality
    }

    static func checkEqualityOfMonthAndYear(dateOne: Date, dateTwo: Date) -> Bool {
        let dateOneMonth = returnCalanderComponent(date: dateOne).month
        let dateTwoMonth = returnCalanderComponent(date: dateTwo).month
        let dateOneYear = returnCalanderComponent(date: dateOne).year
        let dateTwoYear = returnCalanderComponent(date: dateTwo).year
        return dateOneMonth == dateTwoMonth && dateOneYear == dateTwoYear
    }

    static func returnCalanderComponent(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([ .day, .month, .year],
                                               from: date
        )
    }

    static func sortDate(dates: inout [ActivityItem]) {
         dates.sort {$0.date > $1.date}
    }

    static func convertDateStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString)
        else { return Date() }
        return date
    }
}
