import Foundation
import SecureStore

@testable import govuk_ios

class MockSecureStoreService: SecureStorable {
    var _stubbedItemExistsResult: Bool = false
    func checkItemExists(itemName: String) -> Bool {
        return _stubbedItemExistsResult
    }

    var _stubbedReadItemResult: Result<String, Error> = .failure(NSError())
    func readItem(itemName: String) throws -> String {
        switch _stubbedReadItemResult {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    var _savedItems: [String: String] = [:]
    var _stubbedSaveItemResult: Result<Void, Error> = .success(())
    func saveItem(item: String, itemName: String) throws {
        switch _stubbedSaveItemResult {
        case .success:
            _savedItems[itemName] = item
        case .failure(let error):
            throw error
        }
    }

    var _stubbedDeleteItemCalled = false
    func deleteItem(itemName: String) {
        _stubbedDeleteItemCalled = true
        _savedItems.removeValue(forKey: itemName)
    }

    var _stubbedDeleteFailure = false
    var _stubbedDeleteCalled = false
    func delete() throws {
        _stubbedDeleteCalled = true
        if _stubbedDeleteFailure {
            throw NSError()
        }
    }
}
