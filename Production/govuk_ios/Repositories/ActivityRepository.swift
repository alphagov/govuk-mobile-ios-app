import Foundation
import CoreData

protocol ActivityRepositoryInterface {
    func fetch() -> NSFetchedResultsController<ActivityItem>
    func save(params: ActivityItemCreateParams)
    func delete(objectIds: [NSManagedObjectID])
    func deleteAll()
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

    func save(params: ActivityItemCreateParams) {
        let localContext = coreData.backgroundContext
        let local = get(id: params.id, context: localContext) ??
        ActivityItem(context: localContext)
        local.update(params)
        try? localContext.save()
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
        return NSFetchedResultsController<ActivityItem>(
            fetchRequest: request,
            managedObjectContext: fetchContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()
    }

    func delete(objectIds: [NSManagedObjectID]) {
        for objectId in objectIds {
            let object = coreData.backgroundContext.object(with: objectId)
            coreData.backgroundContext.delete(object)
        }
        try? coreData.backgroundContext.save()
    }

    func deleteAll() {
        coreData.deleteAll(
            fetchRequest: ActivityItem.clearRequest()
        )
    }
}
