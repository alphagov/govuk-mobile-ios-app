import Foundation

public class GroupedListToggleRow: GroupedListRow,
                                   ObservableObject {
    public var id: String
    public let title: String
    @Published var isOn: Bool {
        didSet {
            self.action(isOn)
        }
    }
    let action: ((Bool) -> Void)

    public init(id: String,
                title: String,
                isOn: Bool,
                action: @escaping (Bool) -> Void) {
        self.title = title
        self.isOn = isOn
        self.action = action
        self.id = id
    }
}
