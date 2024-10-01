import Foundation
import CoreData

protocol ActivityRepositoryInterface {
    func create(params: ActivityItemCreateParams)
}

class ActivityRepository: ActivityRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func create(params: ActivityItemCreateParams) {
        let localContext = coreData.backgroundContext
        let local = get(id: params.url, context: localContext) ??
        ActivityItem(context: localContext)
        local.update(params)
        try? localContext.save()
    }

    private func get(id: String,
                     context: NSManagedObjectContext?) -> ActivityItem? {
        fetch(
            predicate: .init(format: "url = %@", id),
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
}
