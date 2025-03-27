import Testing
import Foundation
import Factory

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {

    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()

    @Test
    func fetchTopics_downloadSuccess_returnsExpectedData() {
        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        var didHandleError = false
        sut.handleError = { _ in
            didHandleError = true
        }

        sut.fetchTopics()
        #expect(didHandleError == false)
    }

    @Test
    func fetchTopics_downloadFailure_returnsExpectedResult() {
        mockTopicService._stubbedFetchRemoteListResult = .failure(.decodingError)

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        var didHandleError = false
        var topicsError: TopicsServiceError?
        sut.handleError = { error in
            didHandleError = true
            topicsError = error
        }

        sut.fetchTopics()
        #expect(didHandleError == true)
        #expect(topicsError == .decodingError)
    }

    @Test
    @MainActor
    func didTapTopic_invokesExpectedAction() {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
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
    func didTapEdit_invokesExpectedAction() {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
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
    func didTapSeeAllTopics_invokesExpectedAction() {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
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
            analyticsService: mockAnalyticsService,
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
            analyticsService: MockAnalyticsService(),
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
            analyticsService: mockAnalyticsService,
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
            analyticsService: mockAnalyticsService,
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
            analyticsService: mockAnalyticsService,
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
            analyticsService: mockAnalyticsService,
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
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        #expect(sut.widgetTitle == "Topics")
    }

    @Test
    func trackEcommerce_createsExpectedEvent() throws {
        mockTopicService._stubbedHasCustomisedTopics = true

        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        sut.initialLoadComplete = true

        let trackedTopic = try #require(sut.displayedTopics.first?.title)
        sut.trackECommerce()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "view_item_list")
        let parameters = try #require(mockAnalyticsService._trackedEvents.first?.params as? [String: Any])
        #expect(parameters["item_list_id"] as? String == "Homepage")
        #expect(parameters["item_list_name"] as? String == "Homepage")
        #expect(parameters["results"] as? Int == 2)
        let items = try #require((parameters["items"] as? [[String: String]]))
        #expect(items.count == 2)
        let item = try #require(items.first)
        #expect(item["item_name"] == trackedTopic)
        #expect(item["index"] == "1")
        #expect(items.last?["index"] == "2")
    }

    @Test
    func trackEcommerceSelection_createsExpectedEvent() throws {
        mockTopicService._stubbedHasCustomisedTopics = true

        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )

        let trackedTopic = try #require(sut.displayedTopics.first?.title)
        sut.trackECommerceSelection(trackedTopic)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "select_item")
        let parameters = try #require(mockAnalyticsService._trackedEvents.first?.params as? [String: Any])
        #expect(parameters["item_list_id"] as? String == "Homepage")
        #expect(parameters["item_list_name"] as? String == "Homepage")
        #expect(parameters["results"] as? Int == 2)
        let items = try #require((parameters["items"] as? [[String: String]]))
        #expect(items.count == 1)
        let item = try #require(items.first)
        #expect(item["item_name"] == trackedTopic)
        #expect(item["index"] == "1")
    }

}
