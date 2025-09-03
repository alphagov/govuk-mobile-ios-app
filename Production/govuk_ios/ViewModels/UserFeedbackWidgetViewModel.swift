import Foundation

import GOVKit

struct UserFeedbackWidgetViewModel {
    let body: String
    let linkUrl: URL
    let linkTitle: String
    let urlOpener: URLOpener

    init(userFeedback: UserFeedbackBanner,
         urlOpener: URLOpener) {
        body = userFeedback.body
        linkUrl = userFeedback.link.url
        linkTitle = userFeedback.link.title
        self.urlOpener = urlOpener
    }

    func open() {
        urlOpener.openIfPossible(linkUrl)
    }
}
