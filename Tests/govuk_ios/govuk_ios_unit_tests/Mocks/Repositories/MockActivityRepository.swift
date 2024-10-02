import Foundation

@testable import govuk_ios

class MockActivityRepository: ActivityRepositoryInterface {

    var _receivedSaveParams: ActivityItemCreateParams?
    func save(params: ActivityItemCreateParams) {
        _receivedSaveParams = params
    }

}
