import Foundation
import Testing

@testable import govuk_ios

@Suite
struct TopicsOnboardingViewModelTests {
    @Test
    func init_loadsTopicSelectionCards() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topicOne = Topic.arrange(context: coreData.backgroundContext)
        let sut = TopicsOnboardingViewModel(
            topics: [topicOne],
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        #expect(sut.topicSelectionCards.count == 1)
    }

    @Test
    func topicSelectionCard_tapAction_tracksPress() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        let mockAnalyticsService = MockAnalyticsService()
        let sut = TopicsOnboardingViewModel(
            topics: [topic],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelectionCards.first?.tapAction(true)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["action"] as? String == "add")
        #expect(event?.params?["type"] as? String == "Button")
        #expect(event?.params?["section"] as? String == "Topic selection")
        #expect(event?.params?["text"] as? String == topic.title)
    }

    @Test
    func topicSelectionCard_tapAction_true_setsFavourite() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        topic.isFavourite = false
        let sut = TopicsOnboardingViewModel(
            topics: [topic],
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelectionCards.first?.tapAction(true)
        #expect(topic.isFavourite == true)
    }

    @Test
    func topicSelectionCard_tapAction_false_unsetsFavourite() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        topic.isFavourite = true
        let sut = TopicsOnboardingViewModel(
            topics: [topic],
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelectionCards.first?.tapAction(false)
        #expect(topic.isFavourite == false)
    }

    @Test
    func topicSelectionCard_tapAction_true_setsIsTopicSelected() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        let sut = TopicsOnboardingViewModel(
            topics: [topic],
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelectionCards.first?.tapAction(true)
        #expect(sut.isTopicSelected == true)
    }

    @Test
    func primaryAction_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = TopicsOnboardingViewModel(
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
    func primaryAction_savesSelectedFavourites() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topicOne = Topic.arrange(context: coreData.backgroundContext)
        let topicTwo = Topic.arrange(context: coreData.backgroundContext)
        let topicThree = Topic.arrange(context: coreData.backgroundContext)
        let mockAnalyticsService = MockAnalyticsService()
        let sut = TopicsOnboardingViewModel(
            topics: [topicOne, topicTwo, topicThree],
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelectionCards[0].tapAction(true)
        sut.topicSelectionCards[1].tapAction(true)
        sut.topicSelectionCards[2].tapAction(false)

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
        let sut = TopicsOnboardingViewModel(
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
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchAllTopics = [topicOne]
        let sut = TopicsOnboardingViewModel(
            topics: [topicOne],
            analyticsService: mockAnalyticsService,
            topicsService: mockTopicsService,
            dismissAction: { }
        )

        sut.topicSelectionCards[0].tapAction(true)

        sut.secondaryButtonViewModel.action()
        let request = Topic.fetchRequest()
        request.predicate = NSPredicate(format: "isFavourite == true")
        let favourites = try? coreData.backgroundContext.fetch(request)

        #expect(favourites?.count == 0)
    }
}
