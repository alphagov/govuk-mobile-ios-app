import UIKit

protocol URLOpening {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL,
              options: [UIApplication.OpenExternalURLOptionsKey: Any],
              completionHandler completion: ((Bool) -> Void)?
    )
}

extension UIApplication: URLOpening {}
