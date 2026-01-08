import Foundation
import GOVKit

extension AppEvent {
    static func viewItemList(name: String,
                             id: String,
                             items: [ECommerceItem]) -> AppEvent {
        return .init(
            name: "view_item_list",
            params: ["item_list_name": name,
                     "item_list_id": id,
                     "results": items.count,
                     "items": items.map { $0.eventParameters() }]
        )
    }

    static func selectTopicItem(name: String,
                                results: Int,
                                items: [ECommerceItem]) -> AppEvent {
        selectItem(listName: "Topics / " + name,
                   listId: name,
                   results: results,
                   items: items)
    }

    static func selectSearchItem(name: String,
                                 results: Int,
                                 items: [ECommerceItem]) -> AppEvent {
        selectItem(listName: "Search / " + name,
                   listId: name,
                   results: results,
                   items: items)
    }

    static func selectHomePageItem(results: Int,
                                   items: [ECommerceItem]) -> AppEvent {
        selectItem(listName: "Homepage",
                   listId: "Homepage",
                   results: results,
                   items: items)
    }

    static func selectItem(listName: String,
                           listId: String,
                           results: Int,
                           items: [ECommerceItem]) -> AppEvent {
        return .init(
            name: "select_item",
            params: ["item_list_name": listName,
                     "item_list_id": listId,
                     "results": results,
                     "items": items.map { $0.eventParameters() }]
        )
    }
}
