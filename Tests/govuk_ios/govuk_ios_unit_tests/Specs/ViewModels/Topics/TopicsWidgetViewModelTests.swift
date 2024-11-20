import Testing
import Foundation
import Factory

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {

    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()

    @Test
    func initializeModel_downloadSuccess_returnsExpectedData() async throws {
        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.downloadError == nil)
    }

    @Test
    func initializeModel_downloadFailure_returnsExpectedResult() async throws {
        mockTopicService._stubbedFetchRemoteListResult = .failure(.decodingError)

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.downloadError == .decodingError)
    }

    @Test
    @MainActor
    func didTapTopic_invokesExpectedAction() async throws {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
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
            topicsService: mockTopicService,
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
            topicsService: mockTopicService,
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
    func displayedTopics_topicsHaveBeenEdited_returnsFavourites() {
        mockTopicService._stubbedHasCustomisedTopics = true

        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        let result = sut.displayedTopics
        #expect(result.count == 2)
        #expect(result.first == favouriteOne)
        #expect(result.last == favouriteTwo)
    }

    @Test
    func displayedTopics_topicsHaveNotBeenEdited_returnsAllTopcis() {
        mockTopicService._stubbedHasCustomisedTopics = false

        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        let result = sut.displayedTopics
        #expect(result.count == 4)
        #expect(result == mockTopicService._stubbedFetchAllTopics)
        #expect(result.first == allOne)
        #expect(result.last == favouriteTwo)
    }

    @Test
    @MainActor
    func allTopicsButtonHidden_isDisplayingAllTopics_returnsTrue() {
        mockTopicService._stubbedHasCustomisedTopics = false

        let allOne = Topic.arrange(context: coreData.viewContext)
        let allTwo = Topic.arrange(context: coreData.viewContext)

        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.allTopicsButtonHidden)
    }

    @Test
    @MainActor
    func allTopicsButtonHidden_isDisplayingFavourites_allTopicsFavourited_returnsTrue() {
        mockTopicService._stubbedHasCustomisedTopics = true

        let favouriteOne = Topic.arrange(context: coreData.viewContext)
        let favouriteTwo = Topic.arrange(context: coreData.viewContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.allTopicsButtonHidden)
    }

    @Test
    func allTopicsButtonHidden_isDisplayingFavourites_someTopicsFavourited_returnsFalse() {
        mockTopicService._stubbedHasCustomisedTopics = true

        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.allTopicsButtonHidden == false)
    }

    @Test
    func widgetTitle_customisedTopics_returnsExpectedResult() {
        mockTopicService._stubbedHasCustomisedTopics = true
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.widgetTitle == "Your topics")
    }

    @Test
    func widgetTitle_notCustomisedTopics_returnsExpectedResult() {
        mockTopicService._stubbedHasCustomisedTopics = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.widgetTitle == "Topics")
    }

}
