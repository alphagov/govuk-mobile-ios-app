import Testing
import Combine
import Foundation
import Factory

@testable import GOVKitTestUtilities
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
            allTopicsAction: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$fetchTopicsError
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink(
                    receiveValue: { error in
                        print(error)
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
            allTopicsAction: { }
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
            allTopicsAction: { }
        )

        sut.topicAction(Topic(context: coreData.viewContext))
        #expect(expectedValue == true)
    }

    @Test
    func didTapSeeAllTopics_invokesExpectedAction() {
        var expectedValue = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            allTopicsAction: {
                expectedValue = true
            }
        )

        sut.allTopicsAction()
        #expect(expectedValue == true)
    }

    @Test
    func displayedTopics_topicsHaveBeenEdited_returnsFavourites() async {
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
                allTopicsAction: { }
            )
            sut.$topicsToBeDisplayed
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
        }
        #expect(result.count == 2)
        #expect(result.first ==  favouriteOne)
        #expect(result.last ==  favouriteTwo)
    }

    @Test
    func editViewModelAction_setsShowingEditScreenToTrue() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: MockAnalyticsService(),
                topicAction: { _ in },
                allTopicsAction: { }
            )

            sut.$showingEditScreen
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.editButtonViewModel.action()
        }
        #expect(result == true)



    }


    @Test
    func displayedTopics_topicsHaveNotBeenEdited_returnsAllTopcis() async {
        var cancellables = Set<AnyCancellable>()
        let favouriteOne = Topic.arrange(context: coreData.backgroundContext)
        let favouriteTwo = Topic.arrange(context: coreData.backgroundContext)
        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        let result = await withCheckedContinuation { continuation in
            mockTopicService._stubbedHasCustomisedTopics = false

            mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
            mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne, favouriteTwo]

            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: MockAnalyticsService(),
                topicAction: { _ in },
                allTopicsAction: { }
            )

            sut.$topicsToBeDisplayed
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
        }
        #expect(result.count == 4)
        #expect(result == mockTopicService._stubbedFetchAllTopics)
        #expect(result.first == allOne)
        #expect(result.last == favouriteTwo)
    }

    @Test
    @MainActor
    func allTopicsButtonHidden_isDisplayingAllTopics_returnsTrue() async {
        var cancellables = Set<AnyCancellable>()

        let result = await withCheckedContinuation { continuation in
            mockTopicService._stubbedHasCustomisedTopics = false

            let allOne = Topic.arrange(context: coreData.viewContext)
            let allTwo = Topic.arrange(context: coreData.viewContext)

            mockTopicService._stubbedFetchAllTopics = [allOne, allTwo]

            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: mockAnalyticsService,
                topicAction: { _  in },
                allTopicsAction: { }
            )

            sut.$showAllTopicsButton
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
            sut.updateShowAllButtonVisibility()
        }
        #expect(result == true)
    }

    @Test
    @MainActor
    func allTopicsButtonHidden_isDisplayingFavourites_allTopicsFavourited_returnsTrue() async {
        var cancellables = Set<AnyCancellable>()

        let result = await withCheckedContinuation { continuation in
            mockTopicService._stubbedHasCustomisedTopics = true

            let favouriteOne = Topic.arrange(context: coreData.viewContext)
            let favouriteTwo = Topic.arrange(context: coreData.viewContext)

            mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne, favouriteTwo]
            mockTopicService._stubbedFetchAllTopics = [favouriteOne, favouriteTwo]

            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: mockAnalyticsService,
                topicAction: { _ in },
                allTopicsAction: { }
            )
            sut.$showAllTopicsButton
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
            sut.updateShowAllButtonVisibility()
        }

        #expect(result)
    }

    @Test
    func allTopicsButtonHidden_isDisplayingFavourites_someTopicsFavourited_returnsFalse() async {
        var cancellables = Set<AnyCancellable>()

        let result = await withCheckedContinuation { continuation in
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
                allTopicsAction: { }
            )

            sut.$showAllTopicsButton
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
            sut.updateShowAllButtonVisibility()
        }
        #expect(result == false)
    }

    @Test
    func widgetTitle_customisedTopics_returnsExpectedResult() {
        mockTopicService._stubbedHasCustomisedTopics = true
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
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
            allTopicsAction: { }
        )

        #expect(sut.widgetTitle == "Topics")
    }

    @Test
    func showAllButtonViewModelAction_callsAllTopicsAction() async {
        let result: Bool = await withCheckedContinuation { continuation in
            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: mockAnalyticsService,
                topicAction: { _ in },
                allTopicsAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.showAllButtonViewModel.action()
        }
        #expect(result == true)


    }

    @Test
    func trackEcommerce_createsExpectedEvent() async throws {
        var cancellables = Set<AnyCancellable>()

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
            allTopicsAction: { }
        )

        let result = await withCheckedContinuation { continuation in

            sut.initialLoadComplete = true

            sut.$topicsToBeDisplayed
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
            sut.updateShowAllButtonVisibility()
        }

        let trackedTopic = try #require(result.first?.title)
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
    func trackEcommerceSelection_createsExpectedEvent() async throws {
        var cancellables = Set<AnyCancellable>()
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
            allTopicsAction: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$topicsToBeDisplayed
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { val in
                    continuation.resume(returning: val)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
            sut.updateShowAllButtonVisibility()
        }
        guard let trackedTopic = result.first?.title else { return }
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
