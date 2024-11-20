import Foundation
import Testing

@testable import govuk_ios

@Suite
struct TopicOnboardingViewModelTests {

    @Test
    func selectTopic_isSelected_tracksPress() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        try? coreData.backgroundContext.save()
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelected(topic: topic)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["action"] as? String == "add")
        #expect(event?.params?["type"] as? String == "Button")
        #expect(event?.params?["section"] as? String == "Topic selection")
        #expect(event?.params?["text"] as? String == topic.title)
    }

    @Test
    func selectTopic_isFavourite_tracksPress() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        topic.isFavourite = true
        try? coreData.backgroundContext.save()
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelected(topic: topic)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["action"] as? String == "remove")
        #expect(event?.params?["type"] as? String == "Button")
        #expect(event?.params?["section"] as? String == "Topic selection")
        #expect(event?.params?["text"] as? String == topic.title)
    }

    @Test
    func primaryAction_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.primaryButtonViewModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Done")
    }

    @Test
    func selectTopics_thenSave_savedSelectedFavourites() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topicOne = Topic.arrange(context: coreData.backgroundContext)
        topicOne.isFavourite = true
        let topicTwo = Topic.arrange(context: coreData.backgroundContext)
        topicTwo.isFavourite = false
        let topicThree = Topic.arrange(context: coreData.backgroundContext)
        topicThree.isFavourite = true
        _ = Topic.arrange(context: coreData.backgroundContext)
        try? coreData.backgroundContext.save()
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelected(topic: topicOne)
        sut.topicSelected(topic: topicOne)
        sut.topicSelected(topic: topicTwo)
        sut.topicSelected(topic: topicThree)

        sut.primaryButtonViewModel.action()
        let request = Topic.fetchRequest()
        request.predicate = NSPredicate(format: "isFavourite == true")
        let favourites = try? coreData.backgroundContext.fetch(request)

        #expect(favourites?.count == 2)
        #expect(favourites?.contains(topicOne) == true)
        #expect(favourites?.contains(topicTwo) == true)
    }

    @Test
    func secondaryAction_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.secondaryButtonViewModel.action()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["text"] as? String == "Skip")
    }

    @Test
    @MainActor
    func secondaryAction_doenstSaveSelectedFavourites() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topicOne = Topic.arrange(
            context: coreData.viewContext,
            isFavourite: false
        )
        try? coreData.backgroundContext.save()
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchAllTopics = [topicOne]
        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: mockAnalyticsService,
            topicsService: mockTopicsService,
            dismissAction: { }
        )

        sut.topicSelected(topic: topicOne)

        sut.secondaryButtonViewModel.action()
        let request = Topic.fetchRequest()
        request.predicate = NSPredicate(format: "isFavourite == true")
        let favourites = try? coreData.backgroundContext.fetch(request)

        #expect(favourites?.count == 0)
    }

    @Test
    func primaryActionButton_action_tracksEvent() {
        let analyticsService = MockAnalyticsService()
        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: analyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.primaryButtonViewModel.action()

        let receivedTilte = analyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(analyticsService._trackedEvents.count == 1)
        #expect(receivedTilte == "Done")
    }

    @Test
    func secondaryActionButton_action_tracksEvent() {

        let analyticsService = MockAnalyticsService()
        let sut = TopicOnboardingViewModel(
            topics: [],
            analyticsService: analyticsService,
            topicsService: MockTopicsService(),
            dismissAction: {}
        )
        sut.secondaryButtonViewModel.action()
        let receivedTilte = analyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(analyticsService._trackedEvents.count == 1)
        #expect(receivedTilte == "Skip")

    }

    @Test
    func topics_returnsExpectedResult() {
        let coreData = CoreDataRepository.arrangeAndLoad

        let mockTopicsService = MockTopicsService()
        let expectedTopics = Topic.arrangeMultiple(context: coreData.viewContext)
        let sut = TopicOnboardingViewModel(
            topics: expectedTopics,
            analyticsService: MockAnalyticsService(),
            topicsService: mockTopicsService,
            dismissAction: {}
        )

        #expect(sut.topics.count == expectedTopics.count)
    }
}
