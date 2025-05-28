import Foundation

public struct LinkRow: GroupedListRow,
                       Identifiable {
    public let id: String
    public let title: String
    public let body: String?
    public var isWebLink: Bool = true
    public let action: () -> Void

    public init(id: String,
                title: String,
                body: String? = nil,
                isWebLink: Bool = true,
                action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.body = body
        self.isWebLink = isWebLink
        self.action = action
    }
}
