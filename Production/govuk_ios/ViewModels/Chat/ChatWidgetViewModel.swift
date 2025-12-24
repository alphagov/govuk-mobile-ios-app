import Foundation

import GOVKit

struct ChatWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    let id: String
    let title: String
    let body: String
    let linkUrl: URL
    let linkTitle: String
    let urlOpener: URLOpener
    let dismiss: () -> Void

    init(analyticsService: AnalyticsServiceInterface,
         chat: ChatBanner,
         urlOpener: URLOpener,
         dismiss: @escaping () -> Void) {
        id = chat.id
        title = chat.title
        body = chat.body
        linkUrl = chat.link.url
        linkTitle = chat.link.title
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.dismiss = dismiss
    }

    func open() {
        let event = AppEvent.widgetNavigation(text: title)
        analyticsService.track(event: event)
        urlOpener.openIfPossible(linkUrl)
    }
}
