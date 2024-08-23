import Foundation

struct GroupedListSection {
    let heading: String
    let rows: [GroupedListRow]
}

protocol GroupedListRow {
    var title: String { get }
}

struct LinkRow: GroupedListRow {
    let title: String
    let action: () -> Void
}

struct NavigationRow: GroupedListRow {
    let title: String
    let action: () -> Void
}

struct InformationRow: GroupedListRow {
    let title: String
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
                        title: "Information row",
                        detail: "0.0.1"
                    ),
                    LinkRow(
                        title: "Link row", action: {
                            print("link row tapped")
                        }
                    ),
                    NavigationRow(
                        title: "Nav row", action: {
                            print("nav row tapped")
                        }
                    )
                ]
            ),
            .init(
                heading: "Section 2",
                rows: [
                    InformationRow(
                        title: "Information row",
                        detail: "0.0.1"
                    ),
                    LinkRow(
                        title: "Link row", action: {
                            print("link row tapped")
                        }
                    ),
                    NavigationRow(
                        title: "Nav row", action: {
                            print("nav row tapped")
                        }
                    )
                ]
            )
        ]
    }
}
#endif
