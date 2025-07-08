import UIKit

@testable import GOVKit

class MockURLOpener: URLOpener {

    var _receivedCanOpennUrl: URL?
    var _stubbedCanOpenResult: Bool = true
    func canOpenURL(_ url: URL) -> Bool {
        _receivedCanOpennUrl = url
        return _stubbedCanOpenResult
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
