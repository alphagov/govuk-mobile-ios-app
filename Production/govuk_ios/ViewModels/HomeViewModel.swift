import Foundation
import UIKit
import GOVKit

struct HomeViewModel {
    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void

    let widgetBuilder: WidgetBuilder

    var widgets: [WidgetView] {
        var localWidgets = widgetBuilder.getAll()
        if let topicPosition = configService.homeWidgets.firstIndex(of: Feature.topics.rawValue),
           let widget = topicsWidget {
            localWidgets.insert(widget, at: topicPosition)
        }
        return localWidgets
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

    func trackECommerce() {
        topicWidgetViewModel.trackECommerce()
    }
}
