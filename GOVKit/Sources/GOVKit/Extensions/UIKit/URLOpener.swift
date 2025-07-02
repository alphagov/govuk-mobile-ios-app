import Foundation

public protocol URLOpener {
    @discardableResult
    func openIfPossible(_ url: URL) -> Bool

    @discardableResult
    func openIfPossible(_ urlString: String) -> Bool

    @discardableResult
    func canOpenURL(_ url: URL) -> Bool
}

extension URLOpener {
    @discardableResult
    public func openIfPossible(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString)
        else { return false }

        return openIfPossible(url)
    }
}
