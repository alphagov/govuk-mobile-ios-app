import Foundation
public struct ECommerceItem {
    public let name: String
    public let category: String
    public let index: Int
    public let itemId: String?
    public let locationId: String?

    public init(name: String,
                category: String,
                index: Int,
                itemId: String?,
                locationId: String?) {
        self.name = name
        self.category = category
        self.index = index
        self.itemId = itemId
        self.locationId = locationId
    }

    public func eventParameters() -> [String: String] {
        ["item_name": name,
         "item_category": category,
         "index": "\(index)",
         "item_id": itemId ?? "",
         "location_id": locationId ?? ""]
    }
}
