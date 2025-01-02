import UIKit

@testable import GOVKit

class MockURLOpener: URLOpener {

    var _stubbedOpenResult: Bool = true

    var _receivedOpenIfPossibleUrl: URL?
    func openIfPossible(_ url: URL) -> Bool {
        _receivedOpenIfPossibleUrl = url
        return _stubbedOpenResult
    }
}
