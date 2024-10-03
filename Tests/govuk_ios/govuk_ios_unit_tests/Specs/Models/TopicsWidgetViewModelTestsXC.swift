import Factory
import XCTest

@testable import govuk_ios

final class TopicsWidgetViewModelTestsXC: XCTestCase {

    var topicService: MockTopicsService!
    var mockAnalyticsService: MockAnalyticsService!
    override func setUp() {
        super.setUp()
        topicService = MockTopicsService()
        mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register { self.mockAnalyticsService }
    }

    override func tearDown() {
        topicService = nil
        Container.shared.analyticsService.reset()
        super.tearDown()
    }

    func test_fetchTopics_success_returnsExpectedData() async throws {
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in }
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
        }
        
        let topics = try? result.get()
        XCTAssertEqual(topics?.count, 3)
        XCTAssertEqual(topics?.first?.ref, "driving-transport")
    }
    
    func test_fetchTopics_failure_returnsExpectedResult() async throws {
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsFailure

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in }
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchTopics { result in
                continuation.resume(returning: result)
            }
        }
        
        let topics = try? result.get()
        let error = result.getError()
        XCTAssertNil(topics)
        XCTAssertEqual(error, .apiUnavailable)
        
    }
    
    func test_didTapTopic_invokesExpectedAction() async throws {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in
                expectedValue = true
            }
        )
        
        sut.didTapTopic(Topic(ref: "test", title: "Title"))
        XCTAssertTrue(expectedValue)
    }
    
    func test_didTapTopic_sendsEvent() async throws {
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in }
        )
        
        sut.didTapTopic(Topic(ref: "test", title: "Title"))
        XCTAssertEqual(mockAnalyticsService._trackedEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String, "test")
    }
}
