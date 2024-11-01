import Testing
import Foundation
import Factory

@testable import govuk_ios

@Suite
struct TopicsOnboardingWidgetViewModelTests {

    let coreData = CoreDataRepository.arrangeAndLoad
    let topicService = MockTopicsService()

    @Test
    func initializeModel_downloadSuccess_returnsExpectedData() async throws {

        topicService._stubbedDownloadTopicsListResult = .success(TopicResponseItem.arrangeMultiple)

        let sut = TopicsOnboardingListViewModel(
            topicsService: topicService ,
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in }
        )
        #expect(topicService._dataReceived == true)
        #expect(sut.downloadError == nil)
    }

    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        topicService._stubbedDownloadTopicsListResult = .failure(.decodingError)

        let sut = TopicsOnboardingListViewModel(
            topicsService: topicService ,
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in }
        )
        
        #expect(topicService._dataReceived == false)
        #expect(sut.downloadError == .decodingError)
    }

    @Test
    func selectOnboardingTopic_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicsOnboardingListViewModel(
            topicsService: topicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in }
        )

        let testTopic = Topic(context: coreData.viewContext)
        testTopic.ref = "test"
        testTopic.title = "Title"

        sut.selectOnboardingTopic(topic: testTopic, isTopicSelected: true)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Title")
    }

    @Test
    func selectOnboardingTopic_invokesExpectedAction() async throws {
        var expectedValue = false
        let sut = TopicsOnboardingListViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in
                expectedValue = true
            }
        )

        let testTopic = Topic.arrange(context: coreData.viewContext)

        sut.selectOnboardingTopic(topic: testTopic, isTopicSelected: true)
        #expect(expectedValue == true)
    }
}


