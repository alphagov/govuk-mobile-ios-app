import Testing
import Combine
import Foundation
import FactoryKit

@testable import govuk_ios

@Suite
struct TopicsWidgetViewModelTests {

    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()

    @Test
    @MainActor
    func fetchTopics_downloadSuccess_returnsExpectedData() async {
        var cancellables = Set<AnyCancellable>()
        let mockTopicService = MockTopicsService()
        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$fetchTopicsError
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(
                    receiveValue: { error in
                        continuation.resume(returning: error)
                        cancellables.removeAll()
                    }
                ).store(in: &cancellables)
            sut.fetchTopics()
        }
        #expect(result == false)
    }

    @Test
    @MainActor
    func fetchTopics_downloadFailure_returnsExpectedResult() async  {
        var cancellables = Set<AnyCancellable>()
        let mockTopicService = MockTopicsService()
        mockTopicService._stubbedFetchRemoteListResult = .failure(.decodingError)
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$fetchTopicsError
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(
                    receiveValue: { error in
                        continuation.resume(returning: error)
                        cancellables.removeAll()
                    }
                ).store(in: &cancellables)
            sut.fetchTopics()
        }
        #expect(result == true)
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
            dismissEditAction: { }
        )

        sut.topicAction(Topic(context: coreData.viewContext))
        #expect(expectedValue == true)
    }

    @Test
    func fetchAllTopics_returnsCorrectCount() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in

            let allOne = Topic.arrange(context: coreData.backgroundContext)
            let allTwo = Topic.arrange(context: coreData.backgroundContext)

            mockTopicService._stubbedFetchAllTopics = [allOne, allTwo]

            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: mockAnalyticsService,
                topicAction: { _ in },
                dismissEditAction: { }
            )
            sut.$allTopics
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.updateAllTopics()
        }
        #expect(result.count == 2)
    }

    @Test
    func isThereFavouritedTopics_returnsCorrectValue() {
        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)
        mockTopicService._stubbedHasCustomisedTopics = true

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        #expect(sut.hasFavouritedTopics == true)
    }


    @Test
    func topicsToBeDisplayed_topicsHaveBeenEdited_returnsFavourites() async {
        var cancellables = Set<AnyCancellable>()
        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)
        let result = await withCheckedContinuation { continuation in
            mockTopicService._stubbedHasCustomisedTopics = true

            let allOne = Topic.arrange(context: coreData.backgroundContext)
            let allTwo = Topic.arrange(context: coreData.backgroundContext)

            mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
            mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: mockAnalyticsService,
                topicAction: { _ in },
                dismissEditAction: { }
            )
            sut.$favouriteTopics
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.updateFavouriteTopics()
        }
        #expect(result.count == 2)
        #expect(result.first ==  favouriteOne)
        #expect(result.last ==  favouriteTwo)
    }

    @Test
    func widgetTitle_returnsExpectedResult() {
        mockTopicService._stubbedHasCustomisedTopics = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        #expect(sut.widgetTitle == "Topics")
    }

    @Test
    @MainActor
    func setTopicsScreen_allTopics_createsExpectedECommerceEvent() throws {
        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        sut.refreshTopics()
        sut.initialLoadComplete = true
        sut.topicsScreen = .all
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "view_item_list")
        let eventParams = try #require(mockAnalyticsService._trackedEvents.first?.params)
        #expect((eventParams["item_list_name"] as? String) == "All topics")
        #expect((eventParams["item_list_id"] as? String) == "All topics")
        #expect((eventParams["results"] as? Int) == 2)
    }

    @Test
    @MainActor
    func setTopicsScreen_favouriteTopics_createsExpectedECommerceEvent() throws {
        let favouriteOne = Topic.arrange(
            context: coreData.backgroundContext,
            isFavourite: true
        )
        let favouriteTwo = Topic.arrange(
            context: coreData.backgroundContext,
            isFavourite: true
        )

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        sut.initialLoadComplete = true
        sut.refreshTopics()
        sut.topicsScreen = .all
        sut.topicsScreen = .favourite
        #expect(mockAnalyticsService._trackedEvents.count == 2)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "view_item_list")
        let eventParams = try #require(mockAnalyticsService._trackedEvents[1].params)
        #expect((eventParams["item_list_name"] as? String) == "Your topics")
        #expect((eventParams["results"] as? Int) == 2)
    }

    @Test
    @MainActor
    func setTopicsScreen_isTheSameAsOldValue_doesNotCreateECommerceEvent() throws {
        let favouriteOne = Topic.arrange(
            context: coreData.backgroundContext,
            isFavourite: true
        )
        let favouriteTwo = Topic.arrange(
            context: coreData.backgroundContext,
            isFavourite: true
        )
        var lastTopicsScreen = [TopicSegment]()

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        lastTopicsScreen.append(sut.topicsScreen)
        sut.initialLoadComplete = true
        sut.refreshTopics()
        sut.topicsScreen = .favourite
        mockAnalyticsService._trackedEvents = []
        sut.topicsScreen = .favourite
        #expect(mockAnalyticsService._trackedEvents.count == 0)
    }

    @Test
    @MainActor
    func setTopicsScreen_initialLoadCompleteIsFalse_andTopicsIsDifferentFromOldValue_doesNotcreateECommerceEvent() throws {

        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            dismissEditAction: { }
        )
        sut.initialLoadComplete = false
        sut.refreshTopics()
        sut.topicsScreen = .all
        #expect(mockAnalyticsService._trackedEvents.count == 0)
        #expect(mockAnalyticsService._trackedEvents.first?.name == nil)
    }

    @Test
    @MainActor
    func selectingTopic_createsExpectedECommerceEvent() throws {

        let favouriteOne = Topic.arrange(
            context: coreData.backgroundContext,
            ref: "Care",
            title: "Care",
            isFavourite: true
        )
        let favouriteTwo = Topic.arrange(
            context: coreData.backgroundContext,
            isFavourite: true
        )

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]

        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in},
            dismissEditAction: { }
        )

        sut.refreshTopics()
        sut.trackECommerceSelection("Care")
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "select_item")
        let eventParams = try #require(mockAnalyticsService._trackedEvents.first?.params)
        #expect((eventParams["item_list_name"] as? String) == "Your topics")
        #expect((eventParams["results"] as? Int) == 2)
    }
}
