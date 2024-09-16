import Foundation
import XCTest

@testable import govuk_ios

class MockAPIServiceClient: APIServiceClientInterface {
    
    var sendExpectation: XCTestExpectation?
    var _setNetworkRequestResponse = NetworkResult<Data>.success(Data())
    func send(request: GOVRequest,
              completion: @escaping NetworkResultCompletion<Data>) {
        completion(_setNetworkRequestResponse)
        sendExpectation?.fulfill()
    }
}
