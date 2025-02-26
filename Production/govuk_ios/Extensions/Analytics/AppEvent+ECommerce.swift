import Foundation
import GOVKit

extension AppEvent {
    static func viewItemList(name: String,
                             items: [ECommerceItem]) -> AppEvent {
        return .init(
            name: "view_item_list",
            params: ["item_list_name": "Topics",
                     "item_list_id": name,
                     "results": items.count,
                     "items": items.map { $0.eventParameters() }]
        )
    }

    static func selectItem(name: String,
                           results: Int,
                           items: [ECommerceItem]) -> AppEvent {
        return .init(
            name: "select_item",
            params: ["item_list_name": "Topics / " + name,
                     "item_list_id": name,
                     "results": results,
                     "items": items.map { $0.eventParameters() }]
        )
    }
}
