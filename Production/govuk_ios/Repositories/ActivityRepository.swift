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
        activity.url = "https://www.youtube.com/"
        activity.date = Date()

        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com/"
        activityTwo.date = DateHelper.convertDateStringToDate(
            dateString: "2016-04-14T10:44:00+0000")
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = DateHelper.convertDateStringToDate(
            dateString: "2017-04-14T10:44:00+0000")
       try? coreData.backgroundContext.save()
    }
}
