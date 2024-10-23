import Foundation

protocol TopicDetailViewModelInterface: ObservableObject {
    var title: String { get }
    var shouldShowDescription: Bool { get }
    var sections: [GroupedListSection] { get }
    func trackScreen(screen: TrackableScreen)
}

class TopicDetailViewModel: TopicDetailViewModelInterface {
    @Published private(set) var sections = [GroupedListSection]()
    private var topicDetail: TopicDetailResponse?
    private var error: TopicsServiceError?
    private var topic: DisplayableTopic

    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let activityService: ActivityServiceInterface
    private let urlOpener: URLOpener
    private let subtopicAction: (DisplayableTopic) -> Void
    private let stepByStepAction: ([TopicDetailResponse.Content]) -> Void

    var title: String {
        topic.title
    }

    var shouldShowDescription: Bool {
        !(topic is TopicDetailResponse.Subtopic)
    }

    private var subtopicsHeading: String? {
        topicDetail?.content.isEmpty == true ?
        String.topics.localized("subtopicDetailSubtopicsHeader") :
        String.topics.localized("topicDetailSubtopicsHeader")
    }

    init(topic: DisplayableTopic,
         topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface,
         urlOpener: URLOpener,
         subtopicAction: @escaping (DisplayableTopic) -> Void,
         stepByStepAction: @escaping ([TopicDetailResponse.Content]) -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.activityService = activityService
        self.urlOpener = urlOpener
        self.subtopicAction = subtopicAction
        self.stepByStepAction = stepByStepAction
        self.topic = topic

        fetchTopicDetails(topicRef: topic.ref)
    }

    private func fetchTopicDetails(topicRef: String) {
        topicsService.fetchTopicDetails(
            topicRef: topicRef,
            completion: { result in
                switch result {
                case .success(let topicDetail):
                    self.topicDetail = topicDetail
                    self.configureSections()
                case .failure(let error):
                    self.error = error
                }
            }
        )
    }

    private func configureSections() {
        sections = [
            createPopularContentSection(),
            createStepByStepSection(),
            createOtherContentSection(),
            createSubtopicsSection()
        ].compactMap { $0 }
    }

    private func createPopularContentSection() -> GroupedListSection? {
        guard let content = topicDetail?.popularContent else { return nil }
        return GroupedListSection(
            heading: String.topics.localized("topicDetailPopularPagesHeader"),
            rows: content.map { createContentRow($0) },
            footer: nil
        )
    }

    private func createStepByStepSection() -> GroupedListSection? {
        guard let stepBySteps = topicDetail?.stepByStepContent
        else { return nil }
        var rows = [GroupedListRow]()
        if stepBySteps.count > 3 {
            rows = Array(stepBySteps.prefix(3)).map { createContentRow($0) }
            let seeAllRow = NavigationRow(
                id: "topic.stepbystep.showall",
                title: String.topics.localized("topicDetailSeeAllRowTitle"),
                body: nil,
                action: { [weak self] in
                    self?.stepByStepAction(stepBySteps)
                }
            )
            rows.append(seeAllRow)
        } else {
            rows = stepBySteps.map { createContentRow($0) }
        }

        return GroupedListSection(
            heading: String.topics.localized("topicDetailStepByStepHeader"),
            rows: rows,
            footer: nil
        )
    }

    private func createSubtopicsSection() -> GroupedListSection? {
        guard let subtopics = topicDetail?.subtopics,
              subtopics.count > 0
        else { return nil }
        return GroupedListSection(
            heading: subtopicsHeading,
            rows: subtopics.map { createSubtopicRow($0) },
            footer: nil
        )
    }

    private func createOtherContentSection() -> GroupedListSection? {
        guard let content = topicDetail?.otherContent
        else { return nil }
        return GroupedListSection(
            heading: String.topics.localized("topicDetailOtherContentHeader"),
            rows: content.map { createContentRow($0) },
            footer: nil
        )
    }

    private func createContentRow(_ content: TopicDetailResponse.Content) -> LinkRow {
        LinkRow(
            id: content.title,
            title: content.title,
            body: nil,
            action: {
                if self.urlOpener.openIfPossible(content.url) {
                    self.activityService.save(topicContent: content)
                    self.trackLinkEvent(content)
                }
            }
        )
    }

    private func createSubtopicRow(_ content: TopicDetailResponse.Subtopic) -> NavigationRow {
        NavigationRow(
            id: content.ref,
            title: content.title,
            body: nil,
            action: { [weak self] in
                self?.trackSubtopicNavigationEvent(content)
                self?.subtopicAction(content)
            }
        )
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackLinkEvent(_ content: TopicDetailResponse.Content) {
        let event = AppEvent.topicLinkNavigation(content: content)
        analyticsService.track(event: event)
    }

    private func trackSubtopicNavigationEvent(_ subtopic: TopicDetailResponse.Subtopic) {
        let event = AppEvent.subtopicNavigation(subtopic: subtopic)
        analyticsService.track(event: event)
    }
}
