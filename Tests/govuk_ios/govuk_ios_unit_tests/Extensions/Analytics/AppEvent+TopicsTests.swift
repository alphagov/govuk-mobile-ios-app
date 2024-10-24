import Foundation
import Testing

@testable import  govuk_ios

@Suite
struct AppEvent_TopicsTests {
    @Test(arguments:[true, false])
    func toggleTopic_returnsExpectedResult(isFavorite: Bool) {
        let expectedTitle = UUID().uuidString
        let expectedValue = isFavorite ? "On" : "Off"
        let result = AppEvent.toggleTopic(
            title: expectedTitle,
            isFavorite: isFavorite
        )
        #expect(result.name == "Function")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "toggle")
        #expect(result.params?["section"] as? String == "Topics")
        #expect(result.params?["action"] as? String == expectedValue)
    }
    
    @Test(arguments: [true, false])
    func topicLinkNavigation_returnsExpectedResult(isPopular: Bool) {
        let expectedTitle = UUID().uuidString
        let expectedURL = URL(string: "https://www.google.com")!

        let content = TopicDetailResponse.Content(
            title: expectedTitle,
            description: "",
            isStepByStep: false,
            popular: isPopular,
            url: expectedURL
        )
        let result = AppEvent.topicLinkNavigation(content: content)
        #expect(result.name == "Navigation")
        #expect(result.params?.count == 6)
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == (isPopular ? "Popular" : "Services and information"))
        #expect(result.params?["url"] as? String == expectedURL.absoluteString)
    }
    
    @Test
    func stepByStepLinkNavigation_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedURL = URL(string: "https://www.google.com")!

        let content = TopicDetailResponse.Content(
            title: expectedTitle,
            description: "",
            isStepByStep: true,
            popular: false,
            url: expectedURL
        )
        let result = AppEvent.topicLinkNavigation(content: content)
        #expect(result.name == "Navigation")
        #expect(result.params?.count == 6)
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == "Step by steps")
        #expect(result.params?["url"] as? String == expectedURL.absoluteString)
    }
    
    @Test(arguments: ["Test", "Driving"])
    func subtopicNavigation_returnsExpectedResult(title: String) {
        let expectedTitle = title
        let content = TopicDetailResponse.Subtopic(
            ref: "testRef",
            title: title,
            description: "description"
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

