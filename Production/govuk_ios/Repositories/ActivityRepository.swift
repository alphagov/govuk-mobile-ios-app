import Foundation
import CoreData
import GOVKit

protocol ActivityRepositoryInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem>
    func save(params: ActivityItemCreateParams)
    func delete(objectIds: [NSManagedObjectID])
    func returnContext() -> NSManagedObjectContext
    func activityItem(for objectId: NSManagedObjectID) -> ActivityItem?
}

struct ActivityRepository: ActivityRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func fetch() -> NSFetchedResultsController<ActivityItem> {
        fetch(
            predicate: nil,
            context: coreData.viewContext
        )
    }

    func returnContext() -> NSManagedObjectContext {
        return coreData.backgroundContext
    }

    func save(params: ActivityItemCreateParams) {
        let localContext = coreData.backgroundContext
        localContext.performAndWait {
            let local = get(id: params.id, context: localContext) ??
            ActivityItem(context: localContext)
            local.update(params)
            try? localContext.save()
        }
    }

    private func get(id: String,
                     context: NSManagedObjectContext?) -> ActivityItem? {
        fetch(
            predicate: .init(format: "id = %@", id),
            context: context
        ).fetchedObjects?.first
    }

    private func fetch(predicate: NSPredicate?,
                       context: NSManagedObjectContext?)
    -> NSFetchedResultsController<ActivityItem> {
        let fetchContext = context ?? coreData.viewContext
        let request = ActivityItem.fetchRequest()
        request.predicate = predicate
        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: request,
            managedObjectContext: fetchContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? controller.performFetch()
        return controller
    }

    func delete(objectIds: [NSManagedObjectID]) {
        for objectId in objectIds {
            let object = coreData.backgroundContext.object(with: objectId)
            coreData.backgroundContext.delete(object)
        }
        try? coreData.backgroundContext.save()
    }

    func activityItem(for objectId: NSManagedObjectID) -> ActivityItem? {
        try? coreData.viewContext.existingObject(with: objectId) as? ActivityItem
    }
}
