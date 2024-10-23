import Foundation

final class EditTopicsViewModel: ObservableObject {
    @Published private(set) var topics: [Topic] = []
    private let analyticsService: AnalyticsServiceInterface
    private let topicsService: TopicsServiceInterface
    let sections: [GroupedListSection]
    let dismissAction: () -> Void

    init(topicsService: TopicsServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.dismissAction = dismissAction
        self.topicsService = topicsService
        self.analyticsService = analyticsService
        let localTopics = topicsService.fetchAllTopics()
        self.topics = localTopics
        var rows = [GroupedListRow]()
        localTopics.forEach { topic in
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
