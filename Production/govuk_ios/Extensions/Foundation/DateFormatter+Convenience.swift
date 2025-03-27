import Foundation

extension DateFormatter {
    static var recentActivityLastVisited: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }

    static var recentActivityHeader: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}
