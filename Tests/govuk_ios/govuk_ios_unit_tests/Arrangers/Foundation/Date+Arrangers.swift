import Foundation

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
}
