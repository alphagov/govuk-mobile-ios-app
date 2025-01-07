import Foundation
import CoreData

class MockFetchedResultsDelegate<T: NSManagedObject>: NSObject,
                                                      NSFetchedResultsControllerDelegate {
    let controller: NSFetchedResultsController<T>
    var firedAction: (() -> Void)?

    init(controller: NSFetchedResultsController<T>,
         firedAction: (() -> Void)? = nil) {
        self.controller = controller
        self.firedAction = firedAction
        super.init()
        controller.delegate = self
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        firedAction?()
    }

    func retainerMethod() {

    }
}
