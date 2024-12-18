import Foundation
import CoreData

extension NSFetchedResultsController {
    @objc
    @discardableResult
    public func fetch() -> Self {
        try? self.performFetch()
        return self
    }
}
