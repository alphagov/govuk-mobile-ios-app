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
        activity.title = "benefit3"
        activity.url = "https://www.gov.uk/"
        activity.date = Date()

        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.gov.uk/"
        activityTwo.date = Date(timeIntervalSince1970: 1718050294)
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.gov.uk/"
        activityThree.date = Date(timeIntervalSince1970: 1720642294)
        try? coreData.backgroundContext.save()
    }
}
