import Foundation

final class EditTopicsViewModel: ObservableObject {
    @Published var topics: [Topic]
    private let analyticsService: AnalyticsServiceInterface
    private var topicsService: TopicsServiceInterface
    let sections: [GroupedListSection]
    let dismissAction: () -> Void
    private let userDefaults: UserDefaults

    init(topics: [Topic],
         topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaults: UserDefaults,
         dismissAction: @escaping () -> Void) {
        self.topics = topics
        self.dismissAction = dismissAction
        self.topicsService = topicsService
        self.userDefaults = userDefaults
        self.analyticsService = analyticsService

        var rows = [GroupedListRow]()
        topics.forEach { topic in
            let row = ToggleRow(
                id: topic.ref,
                title: topic.title,
                isOn: topic.isFavorite,
                action: { value in
                    topic.isFavorite = value
                    let event = AppEvent.toggleTopic(
                        title: topic.title,
                        isFavorite: topic.isFavorite
                    )
                    analyticsService.track(event: event)
                    topicsService.setHasEditedTopics()
                    topicsService.updateFavoriteTopics()
                }
            )
            rows.append(row)
        }

        sections = [
            GroupedListSection(
                heading: "",
                rows: rows,
                footer: nil
            )
        ]
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
