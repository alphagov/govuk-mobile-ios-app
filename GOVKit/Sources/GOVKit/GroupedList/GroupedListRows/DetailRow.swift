import Foundation

public class DetailRow: GroupedListRow,
                        Identifiable {
    public let id: String
    public let title: String
    public let body: String
    public let destructive: Bool
    public let accessibilityHint: String
    public let action: () -> Void

    public init(id: String,
                title: String,
                body: String,
                accessibilityHint: String,
                destructive: Bool = false,
                action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.body = body
        self.accessibilityHint = accessibilityHint
        self.destructive = destructive
        self.action = action
    }
}
