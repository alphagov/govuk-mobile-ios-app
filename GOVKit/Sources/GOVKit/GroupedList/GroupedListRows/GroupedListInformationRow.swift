import Foundation

public struct GroupedListInformationRow: GroupedListRow,
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
