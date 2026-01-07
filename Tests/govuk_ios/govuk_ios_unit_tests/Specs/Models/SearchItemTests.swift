import Foundation
import Testing

@testable import govuk_ios

@Suite
struct SearchItemTests {
    @Test
    func init_completeValues_returnsItem() throws {
        let expectedTitle = UUID().uuidString
        let expectedContentId = UUID().uuidString
        let expectedDescription = UUID().uuidString
        let expectedHighlightingDescription = UUID().uuidString
        let json = [
            "title": expectedTitle,
            "description_with_highlighting": expectedHighlightingDescription,
            "description": expectedDescription,
            "content_id": expectedContentId,
            "link": "/test",
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        let result = try JSONDecoder().decode(SearchItem.self, from: data)
        #expect(result.title == expectedTitle)
        #expect(result.contentId == expectedContentId)
        #expect(result.link.absoluteString == "https://www.gov.uk/test")
        #expect(result.description == expectedHighlightingDescription)
    }

    @Test
    func init_withDescription_returnsItem() throws {
        let expectedDescription = UUID().uuidString
        let json = [
            "title": UUID().uuidString,
            "description": expectedDescription,
            "link": "/test",
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        let result = try JSONDecoder().decode(SearchItem.self, from: data)
        #expect(result.description == expectedDescription)
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
        #expect(result.link.absoluteString == expectedURL)
    }

    @Test
    func init_invalidLinkURL_returnsError() throws {
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
    func init_withValidBlankValues_returnsItem() throws {
        let expectedTitle = UUID().uuidString
        let json = [
            "title": expectedTitle,
            "description_with_highlighting": nil,
            "description": nil,
            "contentId": nil,
            "link": "/test",
        ]
        let data = try JSONSerialization.data(withJSONObject: json)
        let result = try JSONDecoder().decode(SearchItem.self, from: data)
        #expect(result.description == nil)
        #expect(result.descriptionWithHighlighting == nil)
        #expect(result.contentId == nil)
    }
}
