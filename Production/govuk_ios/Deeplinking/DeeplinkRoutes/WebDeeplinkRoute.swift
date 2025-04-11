import Foundation
import UIKit

struct WebDeeplinkRoute: DeeplinkRoute {
    private let viewControllerBuilder: ViewControllerBuilder

    init(viewControllerBuilder: ViewControllerBuilder) {
        self.viewControllerBuilder = viewControllerBuilder
    }

    var pattern: URLPattern {
        "/web" // Pattern to match web deeplinks
    }

    @MainActor
    func action(parent: BaseCoordinator, params: [String: String]) {
        // The target URL should be in the params
        if let targetUrl = params["url"] {
            print("Raw URL string: \(targetUrl)")

            // Properly decode the URL string before creating the URL object
            let decodedUrlString = targetUrl.removingPercentEncoding ?? targetUrl

            if let url = URL(string: decodedUrlString) {
                print("Decoded URL string: \(decodedUrlString)")
                presentDeeplinkPage(for: url, coordinator: parent)
            } else {
                // Fallback if URL creation fails
                print("Failed to create URL from string: \(targetUrl)")
            }
        } else {
            print("No 'url' parameter found in params: \(params)")
        }
        print("All params received: \(params)")
    }

    @MainActor
    private func presentDeeplinkPage(for url: URL, coordinator: BaseCoordinator) {
        let modalViewController = viewControllerBuilder.webViewController(for: url)
        let navigationController = UINavigationController(rootViewController: modalViewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        coordinator.root.present(navigationController, animated: true)
    }
}
