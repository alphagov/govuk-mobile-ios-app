import UIKit

@testable import govuk_ios

class MockURLOpening: URLOpening {
    var _stubbedCanOpenUrl: Bool = false

    func canOpenURL(_ url: URL) -> Bool {
        return _stubbedCanOpenUrl
    }

    var _receivedOpenCompletion: Bool = false

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        _receivedOpenCompletion = true
    }
}
