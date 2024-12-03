import Foundation

class StepByStepsViewModel: TopicDetailViewModelInterface {
    var errorViewModel: AppErrorViewModel?

    private let content: [TopicDetailResponse.Content]
    private let analyticsService: AnalyticsServiceInterface
    private let activityService: ActivityServiceInterface
    private let urlOpener: URLOpener

    init(content: [TopicDetailResponse.Content],
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface,
         urlOpener: URLOpener) {
        self.content = content
        self.activityService = activityService
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
    }

    var title: String {
        String.topics.localized("topicDetailStepByStepHeader")
    }

    var description: String? {
        nil
    }

    var sections: [GroupedListSection] {
        [
            GroupedListSection(
                heading: nil,
                rows: content.map { createContentRow($0) },
                footer: nil
            )
        ]
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func createContentRow(_ content: TopicDetailResponse.Content) -> LinkRow {
        LinkRow(
            id: content.title,
            title: content.title,
            body: nil,
            action: { [weak self] in
                self?.openContent(content: content)
            }
        )
    }

    private func openContent(content: TopicDetailResponse.Content) {
        if urlOpener.openIfPossible(content.url) {
            activityService.save(topicContent: content)
            trackLinkEvent(content)
        }
    }

    private func trackLinkEvent(_ content: TopicDetailResponse.Content) {
        let event = AppEvent.topicLinkNavigation(
            content: content,
            sectionTitle: String.topics.localized("topicDetailStepByStepHeader")
        )
        analyticsService.track(event: event)
    }
}
