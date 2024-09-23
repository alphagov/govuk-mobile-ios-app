import Foundation

struct MonthGroupKey: Hashable,
                      Equatable {
    let title: String
    let month: Int
    let year: Int

    init(date: Date,
         calendar: Calendar = .current) {
        self.month = calendar.component(.month, from: date)
        self.year = calendar.component(.year, from: date)
        self.title = DateFormatter.recentActivityHeader.string(from: date)
    }
}

extension MonthGroupKey {
    static func > (lhs: MonthGroupKey, rhs: MonthGroupKey) -> Bool {
        lhs.year > rhs.year ||
        (lhs.year == rhs.year && lhs.month > rhs.month)
    }

    static func < (lhs: MonthGroupKey, rhs: MonthGroupKey) -> Bool {
        lhs.year < rhs.year ||
        (lhs.year == rhs.year && lhs.month < rhs.month)
    }
}
