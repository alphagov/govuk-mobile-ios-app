import Foundation

protocol TopicDetailViewModelInterface: ObservableObject {
    var title: String { get }
    var description: String? { get }
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

    var description: String? {
        guard shouldShowDescription
        else { return nil }
        return topicDetail?.description
    }

    var shouldShowDescription: Bool {
        !(topic is TopicDetailResponse.Subtopic)
    }

    private var subtopicsHeading: String? {
        if topic is TopicDetailResponse.Subtopic && topicDetail?.content.isEmpty == true {
            return String.topics.localized("topicDetailSubtopicsHeader")
        } else if topic is TopicDetailResponse.Subtopic {
            return String.topics.localized("subtopicDetailSubtopicsHeader")
        } else {
            return String.topics.localized("topicDetailSubtopicsHeader")
        }
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
        topicsService.fetchDetails(
            ref: topicRef,
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
        let sectionTitle = String.topics.localized("topicDetailPopularPagesHeader")
        return GroupedListSection(
            heading: sectionTitle,
            rows: content.map { createContentRow($0, sectionTitle: sectionTitle) },
            footer: nil
        )
    }

    private func createStepByStepSection() -> GroupedListSection? {
        guard let stepBySteps = topicDetail?.stepByStepContent
        else { return nil }
        var rows = [GroupedListRow]()
        let sectionTitle = String.topics.localized("topicDetailStepByStepHeader")
        if stepBySteps.count > 3 {
            rows = Array(stepBySteps.prefix(3)).map {
                createContentRow($0, sectionTitle: sectionTitle)
            }
            let rowTitle = String.topics.localized("topicDetailSeeAllRowTitle")
            let seeAllRow = NavigationRow(
                id: "topic.stepbystep.showall",
                title: rowTitle,
                body: nil,
                action: { [weak self] in
                    self?.trackLinkEvent(
                        contentTitle: rowTitle,
                        sectionTitle: sectionTitle,
                        external: false
                    )
                    self?.stepByStepAction(stepBySteps)
                }
            )
            rows.append(seeAllRow)
        } else {
            rows = stepBySteps.map { createContentRow($0, sectionTitle: sectionTitle) }
        }

        return GroupedListSection(
            heading: sectionTitle,
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
        let sectionTitle = String.topics.localized("topicDetailOtherContentHeader")
        return GroupedListSection(
            heading: sectionTitle,
            rows: content.map { createContentRow($0, sectionTitle: sectionTitle) },
            footer: nil
        )
    }

    private func createContentRow(_ content: TopicDetailResponse.Content,
                                  sectionTitle: String) -> LinkRow {
        LinkRow(
            id: content.title,
            title: content.title,
            body: nil,
            action: {
                if self.urlOpener.openIfPossible(content.url) {
                    self.activityService.save(topicContent: content)
                    self.trackLinkEvent(
                        content: content,
                        sectionTitle: sectionTitle
                    )
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

    private func trackLinkEvent(content: TopicDetailResponse.Content,
                                sectionTitle: String) {
        let event = AppEvent.topicLinkNavigation(
            content: content,
            sectionTitle: sectionTitle
        )
        analyticsService.track(event: event)
    }

    private func trackLinkEvent(contentTitle: String,
                                sectionTitle: String,
                                external: Bool = false) {
        let event = AppEvent.topicLinkNavigation(
            title: contentTitle,
            sectionTitle: sectionTitle,
            url: nil,
            external: external
        )
        analyticsService.track(event: event)
    }

    private func trackSubtopicNavigationEvent(_ subtopic: TopicDetailResponse.Subtopic) {
        let event = AppEvent.subtopicNavigation(subtopic: subtopic)
        analyticsService.track(event: event)
    }
}
