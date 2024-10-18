import Foundation

class TopicDetailViewModel: ObservableObject {
    @Published var topicDetail: TopicDetailResponse?
    @Published var error: TopicsServiceError?
    var topic: DisplayableTopic
    private let topicsService: TopicsServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let activityService: ActivityServiceInterface
    private let urlOpener: URLOpener
    private let navigationAction: (DisplayableTopic) -> Void

    var sections = [GroupedListSection]()

    var popularContent: [TopicDetailResponse.Content]? {
        guard let popularContent = (topicDetail?.content.filter { $0.popular == true
            && $0.isStepByStep == false }),
              popularContent.count > 0
        else { return nil }
        return popularContent
    }

    var stepByStepContent: [TopicDetailResponse.Content]? {
        guard let stepByStepContent = (topicDetail?.content.filter { $0.isStepByStep == true }),
              stepByStepContent.count > 0
        else { return nil }
        return stepByStepContent
    }

    var otherContent: [TopicDetailResponse.Content]? {
        guard let otherContent = (topicDetail?.content.filter {
            $0.isStepByStep == false && $0.popular == false
        }),
              otherContent.count > 0
        else { return nil }
        return otherContent
    }

    var subtopics: [TopicDetailResponse.Subtopic]? {
        guard let subs = topicDetail?.subtopics,
              subs.count > 0
        else { return nil }
        return subs
    }

    var shouldShowSeeAll: Bool {
        (stepByStepContent?.count ?? 0) > 0 && !isStepByStepSubtopic
    }

    var isStepByStepSubtopic: Bool {
        topic.ref == TopicsService.stepByStepSubTopic.ref
    }

    var subtopicsHeading: String? {
        if shouldHideHeading {
            return nil
        }
        if topic is TopicDetailResponse.Subtopic {
            return String.topics.localized("subtopicDetailSubtopicsHeader")
        }
        return String.topics.localized("topicDetailSubtopicsHeader")
    }

    var shouldHideHeading: Bool {
        isStepByStepSubtopic || [popularContent,
                                 stepByStepContent,
                                 otherContent]
            .compactMap { $0 }.isEmpty
    }

    init(topic: DisplayableTopic,
         topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface,
         urlOpener: URLOpener,
         navigationAction: @escaping (DisplayableTopic) -> Void) {
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        self.activityService = activityService
        self.urlOpener = urlOpener
        self.navigationAction = navigationAction
        self.topic = topic

        self.fetchTopicDetails(for: topic.ref)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func fetchTopicDetails(for topicRef: String) {
        topicsService.fetchTopicDetails(for: topicRef) { result in
            switch result {
            case .success(let topicDetail):
                self.topicDetail = topicDetail
                self.configureSections()
            case .failure(let error):
                self.error = error
            }
        }
    }

    private func configureSections() {
        sections = [createPopularContentSection(),
                    createStepByStepSection(),
                    createOtherContentSection(),
                    createSubtopicsSection()
        ].compactMap { $0 }
    }

    private func createPopularContentSection() -> GroupedListSection? {
        guard let popularContent else { return nil }
        return GroupedListSection(
            heading: String.topics.localized("topicDetailPopularPagesHeader"),
            rows: popularContent.map { createContentRow($0) },
            footer: nil
        )
    }

    private func createStepByStepSection() -> GroupedListSection? {
        guard let stepByStepContent else { return nil }
        var rows = [GroupedListRow]()
        if shouldShowSeeAll {
            rows = Array(stepByStepContent.map { createContentRow($0) }.prefix(3))
            let seeAllRow = NavigationRow(
                id: "seeAllRow",
                title: String.topics.localized("topicDetailSeeAllRowTitle"),
                body: nil,
                action: {
                    self.navigationAction(TopicsService.stepByStepSubTopic)
                    self.trackSubtopicNavigationEvent(TopicsService.stepByStepSubTopic)
                }
            )
            rows.append(seeAllRow)
        } else {
            rows = stepByStepContent.map { createContentRow($0) }
        }

        return GroupedListSection(
            heading:
                (shouldHideHeading ? nil : String.topics.localized("topicDetailStepByStepHeader")),
            rows: rows,
            footer: nil
        )
    }

    private func createSubtopicsSection() -> GroupedListSection? {
        guard let subtopics else { return nil }
        return GroupedListSection(
            heading: subtopicsHeading,
            rows: subtopics.map { createSubtopicRow($0) },
            footer: nil
        )
    }

    private func createOtherContentSection() -> GroupedListSection? {
        guard let otherContent else { return nil }
        return GroupedListSection(
            heading: String.topics.localized("topicDetailOtherContentHeader"),
            rows: otherContent.map { createContentRow($0) },
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
            action: {
                self.trackSubtopicNavigationEvent(content)
                self.navigationAction(content)
            }
        )
    }

    private func trackLinkEvent(_ content: TopicDetailResponse.Content) {
        let event = AppEvent.topicLinkNavigation(content: content)
        analyticsService.track(event: event)
    }

    private func trackSubtopicNavigationEvent(_ subtopic: DisplayableTopic) {
        guard let subtopic = subtopic as? TopicDetailResponse.Subtopic else { return }
        let event = AppEvent.subtopicNavigation(subtopic: subtopic)
        analyticsService.track(event: event)
    }
}
