import UIKit

protocol URLOpener {
    @discardableResult
    func openIfPossible(_ url: URL) -> Bool

    @discardableResult
    func openIfPossible(_ urlString: String) -> Bool
}

extension UIApplication: URLOpener {
    @discardableResult
    func openIfPossible(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString)
        else { return false }

        return openIfPossible(url)
    }

    @discardableResult
    func openIfPossible(_ url: URL) -> Bool {
        guard canOpenURL(url)
        else { return false }
        open(url, options: [:], completionHandler: nil)
        return true
    }
}

extension URLOpener {
    @discardableResult
    func openSettings() -> Bool {
        openIfPossible(UIApplication.openSettingsURLString)
    }
}
