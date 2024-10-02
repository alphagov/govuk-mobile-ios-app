import Foundation
import CoreData

extension NSFetchedResultsController {
    @objc
    @discardableResult
    func fetch() -> Self {
        try? self.performFetch()
        return self
    }
}
