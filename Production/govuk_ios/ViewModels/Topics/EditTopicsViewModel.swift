import Foundation

final class EditTopicsViewModel: ObservableObject {
    @Published var topics: [Topic]
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    let sections: [GroupedListSection]
    private let dismissAction: () -> Void

    init(topics: [Topic],
         topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.topics = topics
        self.dismissAction = dismissAction
        self.topicsService = topicsService
        self.analyticsService = analyticsService

        var rows = [GroupedListRow]()
        topics.forEach { topic in
            rows.append(ToggleRow(id: topic.ref,
                                  title: topic.title,
                                  isOn: topic.isFavorite,
                                  action: { value in
                topic.isFavorite = value
            }))
        }

        sections = [GroupedListSection(heading: "",
                                      rows: rows,
                                      footer: nil)]
    }

    func updateFavoriteTopics() {
        topicsService.updateFavoriteTopics()
        dismissAction()
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
