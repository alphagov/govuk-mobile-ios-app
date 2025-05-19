import GOVKit
import CoreData

protocol CoreDataDeletionServiceInterface {
    func deleteAllObjects() throws
}

class CoreDataDeletionService: CoreDataDeletionServiceInterface {
    private let coreDataRepository: CoreDataRepositoryInterface

    init(coreDataRepository: CoreDataRepositoryInterface) {
        self.coreDataRepository = coreDataRepository
    }

    func deleteAllObjects() throws {
        let context = coreDataRepository.viewContext
        let entities = context.persistentStoreCoordinator?.managedObjectModel.entities ?? []

        try context.performAndWait {
            do {
                for entity in entities {
                    if let entityName = entity.name {
                        try deleteData(for: entityName, in: context)
                    }
                }
            } catch {
                context.rollback()
                throw CoreDataDeletionError.failed
            }
        }
    }

    private func deleteData(for entityName: String,
                            in context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
        NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try context.execute(deleteRequest)
        try context.save()
    }
}

enum CoreDataDeletionError: Error {
    case failed
}
