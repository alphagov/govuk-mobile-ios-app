import Foundation
import GOVKit

struct UserFeedbackWidgetViewModel {
    let body: String
    let linkUrl: URL
    let linkTitle: String
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener

    init(userFeedback: UserFeedbackBanner,
         analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener) {
        body = userFeedback.body
        linkUrl = userFeedback.link.url
        linkTitle = userFeedback.link.title
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
    }

    func open() {
        let event = AppEvent.widgetNavigation(
            text: linkTitle,
            external: true,
            params: ["url": linkUrl.absoluteString]
        )
        analyticsService.track(event: event)
        urlOpener.openIfPossible(linkUrl)
    }
}
