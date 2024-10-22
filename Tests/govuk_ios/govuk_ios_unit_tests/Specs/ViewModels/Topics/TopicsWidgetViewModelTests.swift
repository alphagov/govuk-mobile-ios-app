import Testing
import Factory

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {
    
    let coreData = CoreDataRepository.arrangeAndLoad
    let topicService = MockTopicsService()

    @Test
    func initializeModel_downloadSuccess_returnsExpectedData() async throws {
        
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        
        #expect(topicService._dataReceived == true)
        #expect(sut.downloadError == nil)
    }
    
    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsFailure

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        
        #expect(topicService._dataReceived == false)
        #expect(sut.downloadError == .decodingError)
    }
    
    @Test
    func didTapTopic_invokesExpectedAction() async throws {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in
                expectedValue = true
            },
            editAction: { },
            allTopicsAction: { }
        )
        
        sut.topicAction(Topic(context: coreData.viewContext))
        #expect(expectedValue == true)
    }
    
    @Test
    func didTapEdit_invokesExpectedAction() async throws {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: {
                expectedValue = true
            },
            allTopicsAction: { }
        )
        
        sut.editAction()
        #expect(expectedValue == true)
    }

    @Test
    func didTapSeeAllTopics_invokesExpectedAction() async throws {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: {
                expectedValue = true
            }
        )

        sut.allTopicsAction()
        #expect(expectedValue == true)
    }

    @Test
    func allTopicsButtonHidden_allFavourited_returnsTrue() {
        topicService._allTopicsFavourited = true

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        let result = sut.allTopicsButtonHidden
        #expect(result == true)
    }

    @Test
    func allTopicsButtonHidden_notAllFavourited_returnsFalse() {
        topicService._allTopicsFavourited = false

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        let result = sut.allTopicsButtonHidden
        #expect(result == false)
    }
}
