import Foundation
import Testing

@testable import  govuk_ios

@Suite
struct AppEvent_TopicsTests {
    @Test(arguments:[true, false])
    func toggleTopic_returnsExpectedResult(isFavourite: Bool) {
        let expectedTitle = UUID().uuidString
        let expectedValue = isFavourite ? "On" : "Off"
        let result = AppEvent.toggleTopic(
            title: expectedTitle,
            isFavourite: isFavourite
        )
        #expect(result.name == "Function")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Toggle")
        #expect(result.params?["section"] as? String == "Topics")
        #expect(result.params?["action"] as? String == expectedValue)
    }

    @Test
    func topicLinkNavigation_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedURL = URL(string: "https://www.google.com")!

        let content = TopicDetailResponse.Content.arrange(
            title: expectedTitle,
            url: expectedURL
        )
        let result = AppEvent.topicLinkNavigation(
            content: content,
            sectionTitle: "test_section"
        )
        #expect(result.name == "Navigation")
        #expect(result.params?.count == 6)
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == "test_section")
        #expect(result.params?["url"] as? String == expectedURL.absoluteString)
    }

    @Test
    func topicLinkNavigation_noUrl_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString

        let result = AppEvent.topicLinkNavigation(
            title: expectedTitle,
            sectionTitle: "test_section",
            url: nil,
            external: false
        )
        #expect(result.name == "Navigation")
        #expect(result.params?.count == 5)
        #expect(result.params?["external"] as? Bool == false)
        #expect(result.params?["language"] as? String == "en")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == "test_section")
        #expect(result.params?["url"] as? String == nil)
    }

    @Test
    func stepByStepLinkNavigation_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedURL = URL(string: "https://www.google.com")!

        let content = TopicDetailResponse.Content.arrange(
            title: expectedTitle,
            url: expectedURL
        )
        let result = AppEvent.topicLinkNavigation(
            content: content,
            sectionTitle: "test_section"
        )
        #expect(result.name == "Navigation")
        #expect(result.params?.count == 6)
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == "test_section")
        #expect(result.params?["url"] as? String == expectedURL.absoluteString)
    }

    @Test(arguments: ["Test", "Driving"])
    func subtopicNavigation_returnsExpectedResult(title: String) {
        let expectedTitle = title
        let content = TopicDetailResponse.Subtopic.arrange(
            title: title
        )
        let result = AppEvent.subtopicNavigation(subtopic: content)

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 5)
        #expect(result.params?["language"] as? String == "en")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == "Sub topics")
    }
}

