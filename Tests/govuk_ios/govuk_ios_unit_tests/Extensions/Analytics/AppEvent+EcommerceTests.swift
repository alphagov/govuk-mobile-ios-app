import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AppEvent_EcommerceTests {
    @Test
    func viewItemList_returnsExpectedResult() throws {
        let expectedName = UUID().uuidString
        let expectedItems = ECommerceItem.arrangeItems(count: 3)
        let result = AppEvent.viewItemList(
            name: expectedName,
            items: expectedItems
        )

        #expect(result.name == "view_item_list")
        #expect(result.params?.count == 4)
        #expect(result.params?["item_list_id"] as? String == expectedName)
        #expect(result.params?["item_list_name"] as? String == "Topics")
        #expect(result.params?["results"] as? Int == 3)
        #expect((result.params?["items"] as? [[String: String]])?.count == 3)
        let firstItem = try #require((result.params?["items"] as? [[String: String]])?.first)
        #expect(firstItem["item_name"] == "name 1")
        #expect(firstItem["item_id"] == "item_id 1")
        #expect(firstItem["item_category"] == "category")
        #expect(firstItem["location_id"] == "location_id 1")
        #expect(firstItem["index"] == "1")
    }

    @Test
    func selectItem_returnsExpectedResult() throws {
        let expectedName = UUID().uuidString
        let expectedItems = ECommerceItem.arrangeItems(count: 1)
        let expectedResultCount = 3
        let result = AppEvent.selectItem(
            name: expectedName,
            results: expectedResultCount,
            items: expectedItems
        )

        #expect(result.name == "select_item")
        #expect(result.params?.count == 4)
        #expect(result.params?["item_list_id"] as? String == expectedName)
        #expect(result.params?["item_list_name"] as? String == "Topics / " + expectedName)
        #expect(result.params?["results"] as? Int == expectedResultCount)
        #expect((result.params?["items"] as? [[String: String]])?.count == 1)
        let firstItem = try #require((result.params?["items"] as? [[String: String]])?.first)
        #expect(firstItem["item_name"] == "name 1")
        #expect(firstItem["item_id"] == "item_id 1")
        #expect(firstItem["item_category"] == "category")
        #expect(firstItem["location_id"] == "location_id 1")
        #expect(firstItem["index"] == "1")
    }

}

extension ECommerceItem {
    static func arrange(index: Int) -> ECommerceItem {
        ECommerceItem(name: "name \(index)",
                      category: "category",
                      index: index,
                      itemId: "item_id \(index)",
                      locationId: "location_id \(index)")
    }

    static func arrangeItems(count: Int) -> [ECommerceItem] {
        var items = [ECommerceItem]()
        for index in 1...count {
            let item = ECommerceItem.arrange(index: index)
            items.append(item)
        }
        return items
    }
}
