import Foundation
import Testing

@testable import govuk_ios

@Suite
struct SearchItemTests {
    @Test
    func init_withValidLinkPath_returnsItem() throws {
        let expectedTitle = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let json = [
            "title": expectedTitle,
            "description_with_highlighting": expectedDescription,
            "link": "/test",
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        let result = try JSONDecoder().decode(SearchItem.self, from: data)
        #expect(result.title == expectedTitle)
        #expect(result.description == expectedDescription)
        #expect(result.link.absoluteString == "https://www.gov.uk/test")
    }

    @Test
    func init_withValidLinkURL_returnsItem() throws {
        let expectedTitle = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let expectedURL = "https://www.google.com"
        let json = [
            "title": expectedTitle,
            "description_with_highlighting": expectedDescription,
            "link": expectedURL
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        let result = try JSONDecoder().decode(SearchItem.self, from: data)
        #expect(result.title == expectedTitle)
        #expect(result.description == expectedDescription)
        #expect(result.link.absoluteString == expectedURL)
    }

    @Test
    func init_invalidLinkURL_returnsItem() throws {
        let expectedTitle = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let json = [
            "title": expectedTitle,
            "description_with_highlighting": expectedDescription,
            "link": "test.com/test"
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        do {
            _ = try JSONDecoder().decode(SearchItem.self, from: data)
        } catch {
            #expect(error is DecodingError)
        }
    }

    @Test
    func init_withBlankDescription_returnsItem() throws {
        let expectedTitle = UUID().uuidString
        let json = [
            "title": expectedTitle,
            "description_with_highlighting": nil,
            "link": "/test",
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        let result = try JSONDecoder().decode(SearchItem.self, from: data)
        #expect(result.title == expectedTitle)
        #expect(result.description == nil)
        #expect(result.link.absoluteString == "https://www.gov.uk/test")
    }
}
