import Foundation

import GOVKit

struct AlertBannerWidgetViewModel {
    let id: String
    let body: String
    let linkUrl: URL?
    let linkTitle: String?
    let urlOpener: URLOpener
    let dismiss: () -> Void

    init(alert: AlertBanner,
         urlOpener: URLOpener,
         dismiss: @escaping () -> Void) {
        self.id = alert.id
        self.body = alert.body
        self.linkUrl = alert.link?.url
        self.linkTitle = alert.link?.title
        self.urlOpener = urlOpener
        self.dismiss = dismiss
    }

    func open() {
        guard let localUrl = linkUrl
        else { return }
        urlOpener.openIfPossible(localUrl)
    }
}
