import Foundation

@testable import govuk_ios

class MockActivityService: ActivityServiceInterface {

    var _receivedSaveSearchItem: SearchItem?
    func save(searchItem: SearchItem) {
        _receivedSaveSearchItem = searchItem
    }
}
