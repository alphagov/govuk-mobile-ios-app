import Foundation
import UIKit
import GOVKit
import RecentActivity

struct HomeViewModel {
    @Inject(\.searchService) private var searchService: SearchServiceInterface
    @Inject(\.activityService) private var activityService: ActivityServiceInterface

    let analyticsService: AnalyticsServiceInterface
    let configService: AppConfigServiceInterface
    let topicWidgetViewModel: TopicsWidgetViewModel
    let feedbackAction: () -> Void
    let recentActivityAction: () -> Void
    let urlOpener: URLOpener
    lazy var searchEnabled = featureEnabled(.search)
    lazy var searchViewModel: SearchViewModel = SearchViewModel(
        analyticsService: analyticsService,
        searchService: searchService,
        activityService: activityService,
        urlOpener: urlOpener
    )

    var widgets: [WidgetView] {
        [
//            feedbackWidget,  // see https://govukverify.atlassian.net/browse/GOVUKAPP-1220
            recentActivityWidget,
            topicsWidget
        ].compactMap { $0 }
    }

    private var feedbackWidget: WidgetView {
        let title = String.home.localized("feedbackWidgetTitle")
        let viewModel = UserFeedbackViewModel(
            title: title,
            action: feedbackAction
        )
        let content = UserFeedbackView(viewModel: viewModel)
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.backgroundColor = UIColor.govUK.fills.surfaceCardBlue
        widget.addContent(content)
        return widget
    }

    private var recentActivityWidget: WidgetView? {
        guard featureEnabled(.recentActivity)
        else { return nil }
        let title = String.home.localized(
            "recentActivityWidgetTitle"
        )

        let viewModel = RecentActivityWidgetViewModel(
            title: title,
            action: recentActivityAction
        )
        let content = RecentActivtyWidget(
            viewModel: viewModel
        )
        let widget = WidgetView(useContentAccessibilityInfo: true)
        widget.addContent(content)
        return widget
    }

    private var topicsWidget: WidgetView? {
        guard featureEnabled(.topics)
        else { return nil }
        let content = TopicsWidgetView(
            viewModel: topicWidgetViewModel
        )
        let widget = WidgetView(decorateView: false)
        widget.addContent(content)
        return widget
    }

    private func featureEnabled(_ feature: Feature) -> Bool {
        configService.isFeatureEnabled(key: feature)
    }

    func trackECommerce() {
        topicWidgetViewModel.trackECommerce()
    }
}
