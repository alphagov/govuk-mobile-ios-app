import Testing
import Foundation
import Factory

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    let topicService = MockTopicsService()

    @Test
    func initializeModel_downloadSuccess_returnsExpectedData() async throws {
        
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult
        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        #expect(topicService._dataReceived == true)
        #expect(sut.downloadError == nil)
    }

    @Test
    func hasTopicsBeenEdited_whenSetToTrue_returnsTrue() {

        let mockUserDefaults = UserDefaults()

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        mockUserDefaults.set(bool: true, forKey: .hasEditedTopics)
        #expect(sut.hasTopicsBeenEdited == true)
    }

    @Test
    func hasTopicsBeenEdited_whenSetToFalse_returnsFalse() {
        let mockUserDefaults = UserDefaults()

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        mockUserDefaults.set(bool: false, forKey: .hasEditedTopics)
        #expect(sut.hasTopicsBeenEdited == false)
    }

    @Test
    func getTopics_whenFavouriteTopicsExist_returnsOnlyFavouritedTopics() {
        let mockUserDefaults = UserDefaults()
        let topicService = MockTopicsService()
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        for topic in sut.getTopics {
            #expect(topic.isFavorite == true)
        }
    }

    @Test
    func getTopics_whenFavouriteTopicsDoNotExist_noFavouritedTopicsAreReturned() {
        var mockTopics: [Topic] {
            let result = MockTopicsService.testTopicsResult
            var topics = [Topic]()
            guard let topicResponses = try? result.get() else {
                return topics
            }
            for response in topicResponses {
                let topic = Topic(context: coreData.viewContext)
                topic.title = response.title
                topic.ref = response.ref
                topic.isFavorite = false
                topics.append(topic)
            }
            return topics
        }

        let mockUserDefaults = UserDefaults()
        let topicService = MockTopicsService()
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult
        topicService._stubbedFavouriteTopics = mockTopics

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        for topic in sut.getTopics {
            #expect(topic.isFavorite == false )
        }
    }

    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsFailure
        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        #expect(topicService._dataReceived == false)
        #expect(sut.downloadError == .decodingError)
    }
    
    @Test
    func didTapTopic_invokesExpectedAction() async throws {
        var expectedValue = false
        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in
                expectedValue = true
            },
            editAction: { _ in }
        )
        
        sut.didTapTopic(Topic(context: coreData.viewContext))
        #expect(expectedValue == true)
    }
    
    @Test
    func didTapEdit_invokesExpectedAction() async throws {
        var expectedValue = false
        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in
                expectedValue = true
            }
        )
        
        sut.didTapEdit()
        #expect(expectedValue == true)
    }
    
    @Test
    func didTapTopic_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: mockAnalyticsService,
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )
        
        let testTopic = Topic(context: coreData.viewContext)
        testTopic.ref = "test"
        testTopic.title = "Title"
        sut.didTapTopic(testTopic)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "test")
    }
    
    @Test
    func didTapEdit_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: mockAnalyticsService,
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
        )

        sut.didTapEdit()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "EditTopics")
    }

    @Test
    func selectOnboardingTopic_sendsEvent() {
        let mockAnalyticsService = MockAnalyticsService()

        let mockUserDefaults = UserDefaults()
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: mockAnalyticsService,
            userDefaults: mockUserDefaults,
            topicAction: { _ in },
            editAction: { _ in }
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
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            userDefaults: mockUserDefaults,
            topicAction: { _ in
                expectedValue = true
            },
            editAction: { _ in}
        )

        let testTopic = Topic.arrange(context: coreData.viewContext)

        sut.selectOnboardingTopic(topic: testTopic, isTopicSelected: true)
        #expect(expectedValue == true)
    }
}
