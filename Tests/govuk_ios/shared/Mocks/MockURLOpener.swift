import UIKit
import GOVKit

@testable import govuk_ios

class MockURLOpener: URLOpener {

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
