import Foundation

struct RecentItem: Equatable,
                   Identifiable,
                   Hashable {
    let id: String
    let title: String
    let date: String
    let url: String

    var formattedDate: String {
        let date =  DateHelper.convertDateStringToDate(dateString: date)
        let day = DateHelper.getDay(date: date)
        guard let day = day else { return ""}
        let components = DateHelper.returnCalanderComponent(date: date)
        let month = DateHelper.getMonthName(components: components)
        let dateString = ("Last visited on \(day) \(month)")
        return dateString
    }
}
