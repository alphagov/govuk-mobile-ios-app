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
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelected(topic: topic, selected: true)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["action"] as? String == "add")
    }

    @Test
    func selectTopic_isNotSelected_tracksPress() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        try? coreData.backgroundContext.save()
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelected(topic: topic, selected: false)
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        let event = mockAnalyticsService._trackedEvents.first
        #expect(event?.params?["action"] as? String == "remove")
    }

    @Test
    func selectTopics_thenSave_savedSelectedFavourites() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topicOne = Topic.arrange(context: coreData.backgroundContext)
        let topicTwo = Topic.arrange(context: coreData.backgroundContext)
        let topicThree = Topic.arrange(context: coreData.backgroundContext)
        let topicFour = Topic.arrange(context: coreData.backgroundContext)
        try? coreData.backgroundContext.save()
        let mockAnalyticsService = MockAnalyticsService()

        let sut = TopicOnboardingViewModel(
            analyticsService: mockAnalyticsService,
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        sut.topicSelected(topic: topicOne, selected: true)
        sut.topicSelected(topic: topicOne, selected: true)
        sut.topicSelected(topic: topicTwo, selected: true)
        sut.topicSelected(topic: topicThree, selected: false)

        sut.primaryButtonViewModel.action()
        let request = Topic.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        let favourites = try? coreData.backgroundContext.fetch(request)

        #expect(favourites?.count == 2)
        #expect(favourites?.contains(topicOne) == true)
        #expect(favourites?.contains(topicTwo) == true)
    }

    @Test
    func primaryActionButton_action_tracksEvent() {
        let analyticsService = MockAnalyticsService()
        let sut = TopicOnboardingViewModel(
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
            analyticsService: analyticsService,
            topicsService: MockTopicsService(),
            dismissAction: {}
        )
        sut.secondaryButtonViewModel.action()
        let receivedTilte = analyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(analyticsService._trackedEvents.count == 1)
        #expect(receivedTilte == "Skip")

    }
}
