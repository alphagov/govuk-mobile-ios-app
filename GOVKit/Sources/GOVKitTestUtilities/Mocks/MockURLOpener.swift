import UIKit

@testable import GOVKit

public class MockURLOpener: URLOpener {

    var _stubbedOpenResult: Bool = true
    
    var _receivedOpenIfPossibleUrl: URL?
    
    public init() {}
    public func openIfPossible(_ url: URL) -> Bool {
        _receivedOpenIfPossibleUrl = url
        return _stubbedOpenResult
    }
}
