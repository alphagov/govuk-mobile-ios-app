import Foundation
import GOVKit
import RecentActivity

class StepByStepsViewModel: TopicDetailViewModelInterface {
    var errorViewModel: AppErrorViewModel?
    var commerceItems = [ECommerceItem]()
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

    lazy var sections: [GroupedListSection] = {
        [
            GroupedListSection(
                heading: nil,
                rows: content.map { createContentRow($0) },
                footer: nil
            )
        ]
    }()

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
        trackEcommerce()
    }

    func trackEcommerce() {
        let eCommerceEvent = AppEvent.viewItemList(
            name: String.topics.localized("topicDetailStepByStepHeader"),
            items: commerceItems
        )
        analyticsService.track(event: eCommerceEvent)
    }

    private func createContentRow(_ content: TopicDetailResponse.Content) -> LinkRow {
        createCommerceItem(
            content,
            category: String.topics.localized("topicDetailStepByStepHeader")
        )
        return LinkRow(
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
        guard let commerceEvent = createCommerceEvent(content.title) else { return }
        analyticsService.track(event: commerceEvent)
    }
}
