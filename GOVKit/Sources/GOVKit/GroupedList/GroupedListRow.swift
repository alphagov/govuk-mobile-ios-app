import Foundation

public protocol GroupedListRow {
    var id: String { get }
    var title: String { get }
    var body: String? { get }
}

public extension GroupedListRow {
    var body: String? {
        nil
    }
}
