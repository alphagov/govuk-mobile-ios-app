import Foundation

import GOVKit

struct ChatWidgetViewModel {
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
        id = chat.id
        title = chat.title
        body = chat.body
        linkUrl = chat.link.url
        linkTitle = chat.link.title
        self.urlOpener = urlOpener
        self.dismiss = dismiss
    }

    func open() {
        urlOpener.openIfPossible(linkUrl)
    }
}
