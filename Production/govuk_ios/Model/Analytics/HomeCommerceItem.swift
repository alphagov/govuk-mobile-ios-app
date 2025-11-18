import Foundation

public struct HomeCommerceItem: ECommerceItem {
    public let name: String
    public let listName: String
    public let index: Int
    public let itemId: String?
    public let locationId: String?

    public init(name: String,
                listName: String,
                index: Int,
                itemId: String?,
                locationId: String?) {
        self.name = name
        self.listName = listName
        self.index = index
        self.itemId = itemId
        self.locationId = locationId
    }

    public func eventParameters() -> [String: String] {
        ["item_name": name,
         "index": "\(index)",
         "item_list_id": listName,
         "item_list_name": listName,
         "item_id": itemId ?? "",
         "location_id": locationId ?? ""]
    }
}
