import CoreData
import Foundation

public protocol CoreDataRepositoryInterface {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }

    func load() -> Self
}
