import Foundation

protocol ActivityRepositoryInterface {
}

class ActivityRepository: ActivityRepositoryInterface {
    private let coreData: CoreDataRepositoryInterface

    init(coreData: CoreDataRepositoryInterface) {
        self.coreData = coreData
    }

    func saveTest() {
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefits"
        activity.date = Date()
       try? coreData.backgroundContext.save()
    }
}
