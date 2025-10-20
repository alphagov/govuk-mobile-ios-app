import Foundation
import SwiftUI

public struct GroupedListSection {
    let heading: GroupedListHeader?
    let rows: [GroupedListRow]
    let footer: String?
    
    public init(heading: GroupedListHeader?,
                rows: [GroupedListRow],
                footer: String?) {
        self.heading = heading
        self.rows = rows
        self.footer = footer
    }
}

public struct GroupedListHeader {
    public let title: String
    let icon: UIImage?
    let actionTitle: String?
    let accessibilityActionTitle: String?
    let action: (() -> Void)?

    public init(title: String,
                icon: UIImage? = nil,
                actionTitle: String? = nil,
                accessibilityActionTitle: String? = nil,
                action: (()->Void)? = nil) {
        self.title = title
        self.icon = icon
        self.actionTitle = actionTitle
        self.accessibilityActionTitle = accessibilityActionTitle ?? actionTitle
        self.action = action
    }
}

public protocol GroupedListRow {
    var id: String { get }
    var title: String { get }
    var body: String? { get }
    var imageName: String? { get }
}

public extension GroupedListRow {
    var body: String? {
        nil
    }
    var imageName: String? {
        nil
    }
}

public struct LinkRow: GroupedListRow,
                       Identifiable {
    public let id: String
    public let title: String
    public let body: String?
    public var isWebLink: Bool = true
    public let imageName: String?
    public let showLinkImage: Bool
    public let action: () -> Void
    
    public init(id: String,
                title: String,
                body: String? = nil,
                imageName: String? = nil,
                isWebLink: Bool = true,
                showLinkImage: Bool = true,
                action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.body = body
        self.imageName = imageName
        self.isWebLink = isWebLink
        self.showLinkImage = showLinkImage
        self.action = action
    }
}

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

public struct InformationRow: GroupedListRow,
                              Identifiable {
    public let id: String
    public let title: String
    public let body: String?
    public let imageName: String?
    let detail: String
    
    public init(id: String,
                title: String,
                body: String?,
                imageName: String? = nil,
                detail: String) {
        self.id = id
        self.title = title
        self.body = body
        self.imageName = imageName
        self.detail = detail
    }
}

public class ToggleRow: GroupedListRow,
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

public struct GroupedListSection_Previews: PreviewProvider {
    public static var previews: some View {
        Text("preview")
    }

    public static var previewContent: [GroupedListSection] {
        [
            .init(
                heading: GroupedListHeader(title: "Section 1",
                                           icon: nil,
                                           actionTitle: "See all",
                                           action: { print("tap") }),
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
                    LinkRow(
                        id: UUID().uuidString,
                        title: "Link row with leading icon",
                        body: nil,
                        imageName: "step_by_step",
                        showLinkImage: false,
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
