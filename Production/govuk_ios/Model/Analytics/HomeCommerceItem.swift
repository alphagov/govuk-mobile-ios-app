import Foundation

public struct HomeCommerceItem: ECommerceItem {
    public let name: String
    public let index: Int
    public let itemId: String?
    public let locationId: String?

    public init(name: String,
                index: Int,
                itemId: String?,
                locationId: String?) {
        self.name = name
        self.index = index
        self.itemId = itemId
        self.locationId = locationId
    }

    public func eventParameters() -> [String: String] {
        ["item_name": name,
         "index": "\(index)",
         "item_list_id": "Homepage",
         "item_id": itemId ?? "",
         "location_id": locationId ?? ""]
    }
}
