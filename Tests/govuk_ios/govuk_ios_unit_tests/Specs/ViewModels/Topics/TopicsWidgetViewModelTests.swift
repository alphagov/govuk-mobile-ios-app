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
            topicAction: { _ in }
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
            topicAction: { _ in }
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
            }
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
                topicAction: { _ in }
            )
            sut.$allTopics
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchAllTopics()
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
            topicAction: { _ in }
        )
        #expect(sut.isThereFavouritedTopics == true)
    }

    @Test
    func setTopicsScreen_setTheCorrectSegmentedScreen() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let allOne = Topic.arrange(context: coreData.backgroundContext)
            let allTwo = Topic.arrange(context: coreData.backgroundContext)

            mockTopicService._stubbedFetchAllTopics = [allOne, allTwo]

            let sut = TopicsWidgetViewModel(
                topicsService: mockTopicService,
                analyticsService: mockAnalyticsService,
                topicAction: { _ in }
            )
            sut.$topicsScreen
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.setTopicsScreen()
        }
        #expect(result == 1)
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
                topicAction: { _ in }
            )
            sut.$topicsToBeDisplayed
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                    cancellables.removeAll()
                }.store(in: &cancellables)
            sut.fetchDisplayedTopics()
        }
        #expect(result.count == 2)
        #expect(result.first ==  favouriteOne)
        #expect(result.last ==  favouriteTwo)
    }

    @Test
    func topicsToBeDisplayed_topicsHaveNotBeenEdited_returnsAllTopcis() async {
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
                topicAction: { _ in }
            )

            sut.$topicsToBeDisplayed
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
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
    func widgetTitle_customisedTopics_returnsExpectedResult() {
        mockTopicService._stubbedHasCustomisedTopics = true
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in }
        )

        #expect(sut.widgetTitle == "Your topics")
    }

    @Test
    func widgetTitle_notCustomisedTopics_returnsExpectedResult() {
        mockTopicService._stubbedHasCustomisedTopics = false
        let sut = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in }
        )
        #expect(sut.widgetTitle == "Topics")
    }


}
