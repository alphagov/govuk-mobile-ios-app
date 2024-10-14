import Foundation
import CoreData

protocol ActivityRepositoryInterface {
    func save(params: ActivityItemCreateParams)
    func deleteAllActivities()
    func fetch() -> NSFetchedResultsController<ActivityItem>
}

struct ActivityRepository: ActivityRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func save(params: ActivityItemCreateParams) {
        let localContext = coreData.backgroundContext
        let local = get(id: params.id, context: localContext) ??
        ActivityItem(context: localContext)
        local.update(params)
        try? localContext.save()
    }
    func returnContext() -> NSManagedObjectContext {
        return coreData.backgroundContext
    }

    private func get(id: String,
                     context: NSManagedObjectContext?) -> ActivityItem? {
        fetch(
            predicate: .init(format: "id = %@", id),
            context: context
        ).fetchedObjects?.first
    }

    func deleteAllActivities() {
        guard let fetchRequest = fetch(
            predicate: nil,
            context: coreData.backgroundContext
        ).fetchedObjects else { return }

        for activity in fetchRequest {
            coreData.backgroundContext.delete(activity)
        }
        try? coreData.backgroundContext.save()
    }

    func fetch() -> NSFetchedResultsController<ActivityItem> {
        fetch(predicate: nil,
              context: coreData.viewContext
        )
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
}
