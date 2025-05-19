import Foundation
import Testing

@testable import govuk_ios

class MockCoreDataDeletionService: CoreDataDeletionServiceInterface {
    var _deleteAllObjectsCalled = false
    var _deleteAllObjectsError: Error?
    func deleteAllObjects() throws {
        if let error = _deleteAllObjectsError {
            throw error
        } else {
            _deleteAllObjectsCalled = true
        }
    }
}
