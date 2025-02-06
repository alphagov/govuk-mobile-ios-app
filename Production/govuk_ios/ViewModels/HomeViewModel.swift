import Foundation
import UIKit
import GOVKit

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void
    let searchAction: () -> Void
    let recentActivityAction: () -> Void

    let widgetBuilder: WidgetBuilder

    var widgets: [WidgetView] {
        widgetBuilder.getAll() +
        [
            feedbackWidget,
            topicsWidget
        ].compactMap { $0 }
    }

    private var feedbackWidget: WidgetView {
        let title = String.home.localized("feedbackWidgetTitle")
        let viewModel = WidgetViewModel(
            title: title,
            action: feedbackAction
        )
        let content = UserFeedbackView(viewModel: viewModel)
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardSelected
        widget.addContent(content)
        return widget
    }

    private var topicsWidget: WidgetView? {
        guard widgetEnabled(feature: .topics)
        else { return nil }
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func widgetEnabled(feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }
}
