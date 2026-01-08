import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AppEvent_EcommerceTests {
    @Test
    func viewItemList_topics_returnsExpectedResult() throws {
        let expectedName = UUID().uuidString
        let expectedId = UUID().uuidString
        let expectedItems = TopicCommerceItem.arrangeItems(count: 3)
        let result = AppEvent.viewItemList(
            name: expectedName,
            id: expectedId,
            items: expectedItems
        )

        #expect(result.name == "view_item_list")
        #expect(result.params?.count == 4)
        #expect(result.params?["item_list_id"] as? String == expectedId)
        #expect(result.params?["item_list_name"] as? String == expectedName)
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
    func viewItemList_homepage_returnsExpectedResult() throws {
        let expectedName = UUID().uuidString
        let expectedId = UUID().uuidString
        let expectedItems = HomeCommerceItem.arrangeItems(count: 3)
        let result = AppEvent.viewItemList(
            name: expectedName,
            id: expectedId,
            items: expectedItems
        )

        #expect(result.name == "view_item_list")
        #expect(result.params?.count == 4)
        #expect(result.params?["item_list_id"] as? String == expectedId)
        #expect(result.params?["item_list_name"] as? String == expectedName)
        #expect(result.params?["results"] as? Int == 3)
        #expect((result.params?["items"] as? [[String: String]])?.count == 3)
        let firstItem = try #require((result.params?["items"] as? [[String: String]])?.first)
        #expect(firstItem["item_name"] == "name 1")
        #expect(firstItem["item_id"] == "item_id 1")
        #expect(firstItem["location_id"] == "location_id 1")
        #expect(firstItem["index"] == "1")
    }

    @Test
    func selectTopicItem_returnsExpectedResult() throws {
        let expectedName = UUID().uuidString
        let expectedItems = TopicCommerceItem.arrangeItems(count: 1)
        let expectedResultCount = 3
        let result = AppEvent.selectTopicItem(
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

    @Test
    func selectSearchItem_returnsExpectedResult() throws {
        let expectedName = "Search"
        let expectedItems = SearchCommerceItem.arrangeItems(count: 1)
        let result = AppEvent.selectSearchItem(
            name: expectedName,
            results: 1,
            items: expectedItems
        )

        #expect(result.name == "select_item")
        #expect(result.params?.count == 4)
        #expect(result.params?["item_list_id"] as? String == expectedName)
        #expect(result.params?["item_list_name"] as? String == "Search / " + expectedName)
        #expect(result.params?["results"] as? Int == 1)
        #expect((result.params?["items"] as? [[String: String]])?.count == 1)
        let firstItem = try #require((result.params?["items"] as? [[String: String]])?.first)
        #expect(firstItem["item_name"] == "name 1")
        #expect(firstItem["index"] == "1")
        #expect(firstItem["term"] == "Search term")
        #expect(firstItem["item_location"] == "item_location 1")
        #expect(firstItem["item_id"] == "item_id 1")
    }

    @Test
    func selectHomePageItem_returnsExpectedResult() throws {
        let expectedItems = HomeCommerceItem.arrangeItems(count: 1)
        let expectedResultCount = 3
        let result = AppEvent.selectHomePageItem(
            results: expectedResultCount,
            items: expectedItems
        )

        #expect(result.name == "select_item")
        #expect(result.params?.count == 4)
        #expect(result.params?["item_list_id"] as? String == "Homepage")
        #expect(result.params?["item_list_name"] as? String == "Homepage")
        #expect(result.params?["results"] as? Int == expectedResultCount)
        #expect((result.params?["items"] as? [[String: String]])?.count == 1)
        let firstItem = try #require((result.params?["items"] as? [[String: String]])?.first)
        #expect(firstItem["item_name"] == "name 1")
        #expect(firstItem["item_id"] == "item_id 1")
        #expect(firstItem["location_id"] == "location_id 1")
        #expect(firstItem["index"] == "1")
    }

}

extension TopicCommerceItem {
    static func arrange(index: Int) -> TopicCommerceItem {
        TopicCommerceItem(name: "name \(index)",
                      category: "category",
                      index: index,
                      itemId: "item_id \(index)",
                      locationId: "location_id \(index)")
    }

    static func arrangeItems(count: Int) -> [TopicCommerceItem] {
        var items = [TopicCommerceItem]()
        for index in 1...count {
            let item = TopicCommerceItem.arrange(index: index)
            items.append(item)
        }
        return items
    }
}

extension HomeCommerceItem {
    static func arrange(index: Int) -> HomeCommerceItem {
        HomeCommerceItem(name: "name \(index)",
                         listName: "listName \(index)",
                         index: index,
                         itemId: "item_id \(index)",
                         locationId: "location_id \(index)")
    }
    
    static func arrangeItems(count: Int) -> [HomeCommerceItem] {
        var items = [HomeCommerceItem]()
        for index in 1...count {
            let item = HomeCommerceItem.arrange(index: index)
            items.append(item)
        }
        return items

    }
}

extension SearchCommerceItem {
    static func arrange(index: Int) -> SearchCommerceItem {
        SearchCommerceItem(name: "name \(index)",
                           index: index,
                           term: "Search term",
                           itemLocation: "item_location \(index)",
                           itemId: "item_id \(index)")
    }

    static func arrangeItems(count: Int) -> [SearchCommerceItem] {
        var items = [SearchCommerceItem]()
        for index in 1...count {
            let item = SearchCommerceItem.arrange(index: index)
            items.append(item)
        }
        return items
    }
}
