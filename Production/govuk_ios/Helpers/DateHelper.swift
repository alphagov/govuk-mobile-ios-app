import Foundation

class DateHelper {
    static func getDay(date: Date) -> Int? {
        let component = returnCalanderComponent(date: date)
        guard let day = component.day else { return nil }
        return day
    }

    static func getMonthName(components: DateComponents) -> String {
        guard let componentMonth = components.month else { return "" }
        return  DateFormatter().monthSymbols[componentMonth - 1]
    }

    static func getMonthAndYear(date: Date) -> String {
        let components = returnCalanderComponent(date: date)
        let monthName = getMonthName(components: components)
        let year = components.year
        guard let year = year else { return ""}
        return "\(monthName) \(year)"
    }

    static func checkDatesAreTheSame(dateOne: Date, dateTwo: Date) -> Bool {
        let date1 = returnCalanderComponent(date: dateOne)
        let date2 = returnCalanderComponent(date: dateTwo)
        return date1 == date2
    }

    static func checkEqualityOfMonthAndYear(dateOne: Date, dateTwo: Date) -> Bool {
        let dateOneMonth = returnCalanderComponent(date: dateOne).month
        let dateTwoMonth = returnCalanderComponent(date: dateTwo).month
        let dateOneYear = returnCalanderComponent(date: dateOne).year
        let dateTwoYear = returnCalanderComponent(date: dateTwo).year
        return dateOneMonth == dateTwoMonth && dateOneYear == dateTwoYear
    }

    static func returnCalanderComponent(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([ .day, .month, .year], from: date)
    }

    static func sortDate(dates: inout [ActivityItem]) {
        dates = dates.sorted(by: { dateOne, dateTwo in
                dateOne.date > dateTwo.date
        })
    }

    static func convertDateStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return Date()}
        return date
    }

    static func removeDuplicates(array: [String]) -> [String] {
        var uniqueElements: [String] = []
        for item in array where !uniqueElements.contains(item) {
            uniqueElements.append(item)
        }
        return uniqueElements
    }
}
