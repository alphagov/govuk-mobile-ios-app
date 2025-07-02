import Foundation

@testable import govuk_ios

class MockFileManager: FileManagerInterface {

    var _removedPath: String?
    func removeItem(atPath path: String) throws {
        _removedPath = path
    }
    

    var _stubbedFilePaths: [String] = []
    func fileExists(atPath: String) -> Bool {
        _stubbedFilePaths.contains(atPath)
    }
}
