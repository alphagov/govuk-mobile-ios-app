import Foundation
import SwiftUI

struct GroupedListSection {
    let heading: GroupedListHeader?
    let rows: [GroupedListRow]
    let footer: String?
}

struct GroupedListHeader {
    let title: String
    let icon: UIImage?
}

protocol GroupedListRow {
    var id: String { get }
    var title: String { get }
    var body: String? { get }
}

extension GroupedListRow {
    var body: String? {
        nil
    }
}

struct LinkRow: GroupedListRow,
                Identifiable {
    let id: String
    let title: String
    let body: String?
    var isWebLink: Bool = true
    let action: () -> Void
}

struct NavigationRow: GroupedListRow,
                      Identifiable {
    let id: String
    let title: String
    let body: String?
    let action: () -> Void
}

struct InformationRow: GroupedListRow,
                       Identifiable {
    let id: String
    let title: String
    let body: String?
    let detail: String
}

class ToggleRow: GroupedListRow,
                 ObservableObject {
    var id: String
    let title: String
    @Published var isOn: Bool {
        didSet {
            self.action(isOn)
        }
    }
    let action: ((Bool) -> Void)

    init(id: String,
         title: String,
         isOn: Bool,
         action: @escaping (Bool) -> Void) {
        self.title = title
        self.isOn = isOn
        self.action = action
        self.id = id
    }
}

struct GroupedListSection_Previews: PreviewProvider {
    static var previews: some View {
        Text("preview")
    }

    static var previewContent: [GroupedListSection] {
        [
            .init(
                heading: GroupedListHeader(title: "Section 1", icon: nil),
                rows: [
                    InformationRow(
                        id: UUID().uuidString,
                        title: "Information row",
                        body: "Description",
                        detail: "0.0.1"
                    ),
                    LinkRow(
                        id: UUID().uuidString,
                        title: "Link row",
                        body: "A really long description to test how multiline text wrapping works",
                        action: {
                            print("link row tapped")
                        }
                    ),
                    NavigationRow(
                        id: UUID().uuidString,
                        title: "Nav row",
                        body: "Description",
                        action: {
                            print("nav row tapped")
                        }
                    ),
                    ToggleRow(
                        id: UUID().uuidString,
                        title: "Toggle",
                        isOn: false,
                        action: { isOn in
                            print("Toggled: \(isOn)")
                        }
                    )
                ],
                footer: "some really important text about this section that is long enough to wrap"
            ),
            .init(
                heading: nil,
                rows: [
                    InformationRow(
                        id: UUID().uuidString,
                        title: "Information row",
                        body: "Description",
                        detail: "1.0"
                    ),
                    LinkRow(
                        id: UUID().uuidString,
                        title: "External link row",
                        body: nil,
                        action: {
                            print("link row tapped")
                        }
                    ),
                    NavigationRow(
                        id: UUID().uuidString,
                        title: "Navigation row",
                        body: "Description",
                        action: {
                            print("nav row tapped")
                        }
                    )
                ],
                footer: nil
            ),
            .init(
                heading: GroupedListHeader(
                    title: "Section 2",
                    icon: UIImage(systemName: "house")
                ),
                rows: [
                    InformationRow(
                        id: UUID().uuidString,
                        title: "A really important piece of info",
                        body: nil,
                        detail: "1.0"
                    )
                ],
                footer: "some really important text about this section"
            )
        ]
    }
}
