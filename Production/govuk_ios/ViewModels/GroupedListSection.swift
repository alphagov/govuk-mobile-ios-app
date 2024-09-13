import Foundation

struct GroupedListSection {
    let heading: String?
    let rows: [GroupedListRow]
    let footer: String?
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

struct LinkRow: GroupedListRow, Identifiable {
    let id: String
    let title: String
    let body: String?
    let action: () -> Void
}

struct NavigationRow: GroupedListRow, Identifiable {
    let id: String
    let title: String
    let body: String?
    let action: () -> Void
}

struct InformationRow: GroupedListRow, Identifiable {
    let id: String
    let title: String
    let body: String?
    let detail: String
}

#if DEBUG
extension GroupedListSection {
    static var previewContent: [GroupedListSection] {
        [
            .init(
                heading: "Section 1",
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
                    )
                ],
                footer: nil
            ),
            .init(
                heading: "Section 2",
                rows: [
                    InformationRow(
                        id: UUID().uuidString,
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
            )
        ]
    }
}
#endif
