import Foundation

@testable import govuk_ios

class MockValidator: ValidatorProvider {

    var _validateReceivedInput: String?
    var _stubbedValidateReturnValue: Bool = true
    func validate(input: String?) -> Bool {
        _validateReceivedInput = input
        return _stubbedValidateReturnValue
    }
}
