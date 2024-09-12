import Foundation
import SwiftUI

struct GroupedListSection {
    let heading: String?
    let rows: [GroupedListRow]
    let footer: String?
}

protocol GroupedListRow {
    var title: String { get }
    var body: String? { get }
}

extension GroupedListRow {
    var body: String? {
        nil
    }
}

struct LinkRow: GroupedListRow {
    let title: String
    let body: String?
    let action: () -> Void
}

struct NavigationRow: GroupedListRow {
    let title: String
    let body: String?
    let action: () -> Void
}

struct InformationRow: GroupedListRow {
    let title: String
    let body: String?
    let detail: String
}

class ToggleRow: GroupedListRow, ObservableObject {
    let title: String
    var isOn: Bool {
        didSet {
            self.action(isOn)
        }
    }
    let action: ((Bool) -> Void)

    init(title: String, isOn: Bool, action: @escaping (Bool) -> Void) {
        self.title = title
        self.isOn = isOn
        self.action = action
    }
}

#if DEBUG
extension GroupedListSection {
    static var previewContent: [GroupedListSection] {
        [
            .init(
                heading: "Section 1",
                rows: [
                    InformationRow(
                        title: "Information row",
                        body: "Description",
                        detail: "0.0.1"
                    ),
                    LinkRow(
                        title: "Link row",
                        body: "A really long description to test how multiline text wrapping works",
                        action: {
                            print("link row tapped")
                        }
                    ),
                    NavigationRow(
                        title: "Nav row",
                        body: "Description",
                        action: {
                            print("nav row tapped")
                        }
                    ),
                    ToggleRow(
                        title: "Toggle",
                        isOn: false,
                        action: { isOn in
                            print("Toggled: \(isOn)")
                        }
                    )
                ],
                footer: nil
            ),
            .init(
                heading: "Section 2",
                rows: [
                    InformationRow(
                        title: "A really important piece of info",
                        body: nil,
                        detail: "1.0"
                    )
                ],
                footer: "some really important text about this section"
            ),
            .init(
                heading: nil,
                rows: [
                    InformationRow(
                        title: "Information row",
                        body: "Description",
                        detail: "1.0"
                    ),
                    LinkRow(
                        title: "External link row",
                        body: nil,
                        action: {
                            print("link row tapped")
                        }
                    ),
                    NavigationRow(
                        title: "Navigation row",
                        body: "Description",
                        action: {
                            print("nav row tapped")
                        }
                    )
                ],
                footer: nil
            )
        ]
    }
}
