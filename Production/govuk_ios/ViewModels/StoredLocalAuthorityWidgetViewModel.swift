import Foundation
import GOVKit

struct StoredLocalAuthrorityWidgetViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    let model: LocalAuthorityItem

    init(analyticsService: AnalyticsServiceInterface,
         model: LocalAuthorityItem,
         urlOpener: URLOpener) {
        self.analyticsService = analyticsService
        self.model = model
        self.urlOpener = urlOpener
    }

    func openURL(url: String, title: String) {
        if let url = URL(string: url) {
            openURLIfPossible(
                url: url,
                eventTitle: title
            )
        }
    }

    private func trackNavigationEvent(_ title: String,
                                      external: Bool) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: external
        )
        analyticsService.track(event: event)
    }

    func openURLIfPossible(url: URL,
                           eventTitle: String) {
        if urlOpener.openIfPossible(url) {
            trackNavigationEvent(
                eventTitle,
                external: true
            )
        }
    }
}
