import Foundation

@testable import govuk_ios

class MockAPIServiceClient: APIServiceClientInterface {
    
    var _receivedSendRequest: GOVRequest?
    var _receivedSendCompletion: NetworkResultCompletion<Data>?
    var _stubbedSendResponse: NetworkResult<Data>?
    func send(request: GOVRequest,
              completion: @escaping NetworkResultCompletion<Data>) {
        _receivedSendRequest = request
        _receivedSendCompletion = completion
        if let response = _stubbedSendResponse {
            completion(response)
        }
    }
}
