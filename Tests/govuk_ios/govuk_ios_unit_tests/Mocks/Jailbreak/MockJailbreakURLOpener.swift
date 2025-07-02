import UIKit

@testable import GOVKit

class MockJailbreakURLOpener: URLOpener {

    var _openableURLS: [String] = []
    func canOpenURL(_ url: URL) -> Bool {
        let urls = _openableURLS.compactMap { URL(string: $0) }
        return urls.contains(url)
    }

    var _stubbedOpenResult: Bool = true
    var _receivedOpenIfPossibleUrl: URL?
    func openIfPossible(_ url: URL) -> Bool {
        _receivedOpenIfPossibleUrl = url
        return _stubbedOpenResult
    }

    var _receivedOpenIfPossibleUrlString: String?
    func openIfPossible(_ urlString: String) -> Bool {
        _receivedOpenIfPossibleUrlString = urlString
        return _stubbedOpenResult
    }

}
