import Foundation
import UIKit

struct WebDeeplinkRoute: DeeplinkRoute {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder) {
        self.coordinatorBuilder = coordinatorBuilder
    }

    var pattern: URLPattern {
        "/web"
    }

    @MainActor
    func action(parent: BaseCoordinator, params: [String: String]) {
        if let targetUrl = params["url"],
            let url = URL(string: targetUrl),
            url.scheme != nil && (url.scheme == "http" || url.scheme == "https") {
            presentDeeplinkPage(for: url, coordinator: parent)
        }
    }

    @MainActor
    private func presentDeeplinkPage(for url: URL, coordinator: BaseCoordinator) {
        let webCoordinator = coordinatorBuilder.webView(url: url)
        coordinator.present(webCoordinator)
    }
}
