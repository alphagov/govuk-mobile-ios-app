import Foundation

public struct NavigationRow: GroupedListRow,
                             Identifiable {
    public let id: String
    public let title: String
    public let body: String?
    let action: () -> Void

    public init(id: String,
                title: String,
                body: String?,
                action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.body = body
        self.action = action
    }
}
