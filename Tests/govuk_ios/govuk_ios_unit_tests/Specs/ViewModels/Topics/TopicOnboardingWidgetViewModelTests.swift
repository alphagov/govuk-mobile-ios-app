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

        let sut = TopicsOnboardingWidgetViewModel(
            topicsService: topicService ,
            analyticsService: MockAnalyticsService(),
            userDefaults: UserDefaults(),
            topicAction: { _ in }
        )

        #expect(topicService._dataReceived == true)
        #expect(sut.downloadError == nil)
    }

    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        topicService._stubbedDownloadTopicsListResult = .failure(.decodingError)

        let sut = TopicsOnboardingWidgetViewModel(
            topicsService: topicService ,
            analyticsService: MockAnalyticsService(),
            userDefaults: UserDefaults(),
            topicAction: { _ in }
        )

        #expect(topicService._dataReceived == false)
        #expect(sut.downloadError == .decodingError)
    }

    @Test
    func getTopics_whenFavouriteTopicsExist_returnsOnlyFavouritedTopics() {
        let topicService = MockTopicsService()

        let topicOne = Topic(context: coreData.backgroundContext)
        topicOne.isFavorite = true
        let topicTwo = Topic(context: coreData.backgroundContext)
        topicTwo.isFavorite = true

        topicService._stubbedFetchAllTopics = [topicOne, topicTwo]

        let sut = TopicsOnboardingWidgetViewModel(
            topicsService: topicService ,
            analyticsService: MockAnalyticsService(),
            userDefaults: UserDefaults(),
            topicAction: { _ in }
        )

        for topic in sut.getTopics {
            #expect(topic.isFavorite == true)
        }
    }

    @Test
    func getTopics_whenFavouriteTopicsDoNotExist_noFavouritedTopicsAreReturned() {

        let topicService = MockTopicsService()

        let topicOne = Topic(context: coreData.backgroundContext)
        topicOne.isFavorite = false
        let topicTwo = Topic(context: coreData.backgroundContext)
        topicTwo.isFavorite = false

        topicService._stubbedFetchAllTopics = [topicOne, topicTwo]

        let sut = TopicsOnboardingWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: UserDefaults(),
            topicAction: { _ in }
        )
        for topic in sut.getTopics {
            #expect(topic.isFavorite == false)
        }
    }

    @Test
    func selectOnboardingTopic_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()

        let mockUserDefaults = UserDefaults()
        let sut = TopicsOnboardingWidgetViewModel(
            topicsService: topicService,
            analyticsService: mockAnalyticsService,
            userDefaults: mockUserDefaults,
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
        let mockUserDefaults = UserDefaults()
        let sut = TopicsOnboardingWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in
                expectedValue = true
            }
        )

        let testTopic = Topic.arrange(context: coreData.viewContext)

        sut.selectOnboardingTopic(topic: testTopic, isTopicSelected: true)
        #expect(expectedValue == true)
    }
}


