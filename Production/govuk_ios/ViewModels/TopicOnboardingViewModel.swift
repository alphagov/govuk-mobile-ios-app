import Foundation

struct TopicOnboardingViewModel {
    let topicWidgetViewModel: TopicsWidgetViewModel
    let analyticsService: AnalyticsService

    var widgets: [WidgetView] {
        [topicsWidget]
    }

    private var topicsWidget: WidgetView {
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private var selectableTopicsWidget: WidgetView? {
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }
}
