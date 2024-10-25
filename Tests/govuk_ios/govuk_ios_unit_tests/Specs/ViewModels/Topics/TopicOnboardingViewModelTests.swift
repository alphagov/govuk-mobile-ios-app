import Foundation
import Testing

@testable import govuk_ios

@Suite
struct TopicOnboardingViewModelTests {

    @Test
    func selectTopic_whenTopicDoesNotExistInSelectedTopics_appendsTopic() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        try? coreData.backgroundContext.save()

        let sut = TopicOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )
        #expect(sut.selectedTopics == [:])

        sut.selectTopic(topic: topic)

        #expect(sut.selectedTopics[topic.title] != nil)
    }

    @Test
    func selectTopic_whenTopicAlreadyExistsInSelectedTopics_removesTopic() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: coreData.backgroundContext)
        try? coreData.backgroundContext.save()

        let sut = TopicOnboardingViewModel(
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: {}
        )
        #expect(sut.selectedTopics == [:])
        sut.selectTopic(topic: topic)
        #expect(sut.selectedTopics[topic.title] != nil)

        sut.selectTopic(topic: topic)
        #expect(sut.selectedTopics == [:])
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
