import Foundation

public struct SearchCommerceItem: ECommerceItem {
    public let name: String
    public let index: Int
    public let term: String
    public let itemLocation: String
    public let itemId: String?

    public init(name: String,
                index: Int,
                term: String,
                itemLocation: String,
                itemId: String?) {
        self.name = name
        self.index = index
        self.term = term
        self.itemLocation = itemLocation
        self.itemId = itemId
    }

    public func eventParameters() -> [String: String] {
        ["item_name": name,
         "index": "\(index)",
         "term": "\(term)",
         "item_location": itemLocation,
         "item_id": itemId ?? ""]
    }
}
