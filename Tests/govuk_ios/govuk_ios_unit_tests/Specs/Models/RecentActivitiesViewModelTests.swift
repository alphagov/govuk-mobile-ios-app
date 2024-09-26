import SwiftUI
import CoreData
import Testing

@testable import govuk_ios

@Suite
struct RecentActivitiesViewModelTests {

    @Test
    func sortActivities_whenActivitiesDateEqualsToday_populatesTodaysActivitesList() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()
        let sut = RecentActivitiesViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )

        var activitiesArray: [ActivityItem] = []
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefits"
        activity.url = "https://www.youtube.com/"
        activity.date = Date()
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit"
        activityTwo.url = "https://www.youtube.com/"
        activityTwo.date = Date()
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = Date()

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)

        #expect(structure.todaysActivites.count == 3)
        #expect(structure.recentMonthActivities.count == 0)
        #expect(structure.currentMonthActivities.count == 0)
    }

    @Test
    func sortItems_whenActivitesDateEqualsCurrentMonth_currentMonthsListIsPopulated() throws {
        let sut = RecentActivitiesViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        var activitiesArray: [ActivityItem] = []

        let randomDateOne = Date.arrangeRandomDateFromThisMonthNotToday
        let randomDateTwo = Date.arrangeRandomDateFromThisMonthNotToday
        let randomDateThree = Date.arrangeRandomDateFromThisMonthNotToday

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com/"
        activity.date = randomDateOne
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com/"
        activityTwo.date = randomDateTwo
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = randomDateThree

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)
        #expect(structure.todaysActivites.count == 0)
        #expect(structure.recentMonthActivities.count == 0)
        #expect(structure.currentMonthActivities.count == 3)
    }

    @Test
    func sortItems_whenActivitesDateEqualsRecentMonths_currentMonthsListIsPopulated() throws {
        let sut = RecentActivitiesViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        var activitiesArray:[ActivityItem] = []

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com/"
        activity.date = .arrange("14/04/2004")
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com/"
        activityTwo.date = .arrange("14/04/2016")
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = .arrange("14/04/2017")

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)

        #expect(structure.todaysActivites.count == 0)
        #expect(structure.recentMonthActivities.count == 3)
        #expect(structure.currentMonthActivities.count == 0)
    }

    @Test
    func trackRecentActivity_tracksEvent() {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let analyticsService = MockAnalyticsService()
        let sut = RecentActivitiesViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared
        )
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.title = "Benefits"
        try? coreData.backgroundContext.save()
        sut.trackRecentActivity(activity: activity)

        #expect(analyticsService._trackedEvents.count == 1)
        #expect(analyticsService._trackedEvents.first?.name == "RecentActivity")
    }
}
