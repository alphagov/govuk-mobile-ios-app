import Foundation

@testable import govuk_ios

class MockRedactor: Redactor {
    var _receivedInputText: String?
    var _stubbedRedactedString: String?
    override func redact(_ text: String) -> String {
        _receivedInputText = text
        return _stubbedRedactedString!
    }
}
