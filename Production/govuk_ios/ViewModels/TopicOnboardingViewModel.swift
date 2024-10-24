import Foundation
import UIComponents

class TopicOnboardingViewModel: ObservableObject {
    let analyticsService: AnalyticsServiceInterface
    let topicsService: TopicsServiceInterface
    let dismissAction: () -> Void
    @Published var isTopicsSelected: Bool = false
    var selectedTopics: [String: Topic] = [:]
    let navigationTitle = String.topics.localized(
        "topicOnboardingNavigationTitle"
    )
    private let primaryButtonTitle = String.topics.localized(
        "topicsOnboardingPrimaryBtnTitle"
    )
    private let secondaryButtonTitle = String.topics.localized(
        "topicsOnboardingSecondaryBtnTitle"
    )

    init(analyticsService: AnalyticsServiceInterface,
         topicsService: TopicsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.topicsService = topicsService
        self.dismissAction = dismissAction
    }

    var widgets: [WidgetView] {
        [topicsWidget]
    }

    func selectTopic(topic: Topic) {
        if let topic = selectedTopics[topic.title] {
            selectedTopics.removeValue(forKey: topic.title)
        } else {
            selectedTopics[topic.title] = topic
        }
        setHasTopicsBeenSelected()
    }

    private func setHasTopicsBeenSelected() {
        isTopicsSelected = selectedTopics.isEmpty ? false : true
    }

    private var topicsWidget: WidgetView {
        let topicWidgetViewModel = TopicsWidgetViewModel(
            topicsService: topicsService,
            analyticsService: analyticsService,
            userDefaults: .standard,
            topicAction: { [weak self] topic in
                guard let self = self else { return }
                self.selectTopic(topic: topic)
            },
            editAction: nil
        )

        let content = TopicsOnboardingWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: secondaryButtonTitle,
            action: { [weak self] in
                self?.skipAction()
            }
        )
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: primaryButtonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                self.saveFavouriteTopics()
                self.trackPrimaryEvent()
                self.finishSelectionAction()
            }
        )
    }

    private func skipAction() {
        self.trackSecondaryEvent()
        self.dismissAction()
    }

    private func finishSelectionAction() {
        self.dismissAction()
    }

    func saveTopicsToFavourite() {
        for (_, value) in selectedTopics {
            value.isFavorite = true
        }
    }

    private func saveFavouriteTopics() {
        saveTopicsToFavourite()
        topicsService.updateFavoriteTopics()
    }

    private func trackPrimaryEvent() {
        let event = AppEvent.buttonNavigation(
            text: "Done",
            external: false
        )
        analyticsService.track(event: event)
    }

    private func trackSecondaryEvent() {
        let event = AppEvent.buttonNavigation(
            text: "Skip",
            external: false
        )
        analyticsService.track(event: event)
    }
}
