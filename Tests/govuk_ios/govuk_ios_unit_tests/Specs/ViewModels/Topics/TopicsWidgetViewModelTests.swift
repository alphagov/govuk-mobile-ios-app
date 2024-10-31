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
        
        topicService._stubbedDownloadTopicsListResult = .success(TopicResponseItem.arrangeMultiple)

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        
        #expect(topicService._dataReceived == true)
        #expect(sut.downloadError == nil)
    }
    
    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        topicService._stubbedDownloadTopicsListResult = .failure(.decodingError)

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
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
            userDefaults: UserDefaults(),
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
            userDefaults: UserDefaults(),
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
            userDefaults: UserDefaults(),
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
        topicService._stubbedFetchFavoriteTopics = [
            .arrange(context: coreData.viewContext, isFavourite: true)
        ]
        topicService._stubbedFetchAllTopics = [
            .arrange(context: coreData.viewContext, isFavourite: true)
        ]

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        let result = sut.allTopicsButtonHidden
        #expect(result == true)
    }

    @Test
    func allTopicsButtonHidden_notAllFavourited_returnsFalse() {
        topicService._stubbedFetchFavoriteTopics = [
            .arrange(
                context:coreData.viewContext,
                     isFavourite: true
            )
        ]
        topicService._stubbedFetchAllTopics = [
            .arrange(
                context: coreData.viewContext,
                isFavourite: false
            ),
            .arrange(
                context: coreData.viewContext,
                isFavourite: false
            )
        ]
        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let result = sut.allTopicsButtonHidden
        #expect(result == false)
    }

    @Test
    func getTopics_whenFavouriteTopicsExist_returnsOnlyFavouritedTopics() {
        let topicService = MockTopicsService()

        let topicOne = Topic(context: coreData.backgroundContext)
        topicOne.isFavorite = true
        let topicTwo = Topic(context: coreData.backgroundContext)
        topicTwo.isFavorite = true

        topicService._stubbedFetchAllTopics = [topicOne, topicTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        for topic in sut.topics {
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

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        
        for topic in sut.topics {
            #expect(topic.isFavorite == false)
        }
    }

    @Test
    func allTopicsButtonHidden_topicsCountIsNotGreaterOrEqualToFetchAllTopicsCount_returnsFalse() {

        let topicService = MockTopicsService()

        topicService._stubbedFetchFavoriteTopics = [
            .arrange(context: coreData.viewContext, isFavourite: true)
        ]
        topicService._stubbedFetchAllTopics = [
            .arrange(context: coreData.viewContext, isFavourite: false),
            .arrange(context: coreData.viewContext, isFavourite: false),
            .arrange(context: coreData.viewContext, isFavourite: false)
        ]

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        #expect(sut.allTopicsButtonHidden == false)
    }

    @Test
    func allTopicsButtonHidden_topicsCountIsGreaterOrEqualToFetchAllTopicsCount_returnsTrue() {

        let topicService = MockTopicsService()

        topicService._stubbedFetchFavoriteTopics = [
            .arrange(context: coreData.viewContext, isFavourite: true),
            .arrange(context: coreData.viewContext, isFavourite: true),
            .arrange(context: coreData.viewContext, isFavourite: true)
        ]
        topicService._stubbedFetchAllTopics = [
            .arrange(context: coreData.viewContext, isFavourite: false),
            .arrange(context: coreData.viewContext, isFavourite: false),
            .arrange(context: coreData.viewContext, isFavourite: false)
        ]

        let sut = TopicsWidgetViewModel(
            topicsService: topicService,
            userDefaults: UserDefaults(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        #expect(sut.allTopicsButtonHidden == true)
    }
}

