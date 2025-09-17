import Foundation

import GOVKit

struct ChatBannerWidgetViewModel {
    let id: String
    let title: String
    let body: String
    let linkUrl: URL
    let linkTitle: String
    let urlOpener: URLOpener
    let dismiss: () -> Void

    init(chat: ChatBanner,
         urlOpener: URLOpener,
         dismiss: @escaping () -> Void) {
        self.id = chat.id
        self.title = chat.title
        self.body = chat.body
        self.linkUrl = chat.link.url
        self.linkTitle = chat.link.title
        self.urlOpener = urlOpener
        self.dismiss = dismiss
    }

    func open() {
        urlOpener.openIfPossible(linkUrl)
    }
}
