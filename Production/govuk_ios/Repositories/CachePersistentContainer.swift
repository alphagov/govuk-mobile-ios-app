import Foundation
import CoreData

class CachePersistentContainer: NSPersistentContainer,
                                @unchecked Sendable {
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.urls(
            for: .cachesDirectory,
            in: .allDomainsMask
        )[0]
    }
}
