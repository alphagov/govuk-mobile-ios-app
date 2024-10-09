import SwiftUI
import CoreData
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct RecentActivitiesContainerViewModelTests {

    @Test
    func sortActivities_whenActivitiesDateEqualsToday_populatesTodaysActivitesList() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let sut = RecentActivitiesContainerViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )

        var activitiesArray: [ActivityItem] = []
        let activity = ActivityItem(context: coreData.viewContext)
        activity.id = UUID().uuidString
        activity.title = "benefits"
        activity.url = "https://www.youtube.com"
        activity.date = Date()
        let activityTwo = ActivityItem(context: coreData.viewContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = Date()
        let activityThree = ActivityItem(context: coreData.viewContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com"
        activityThree.date = Date()

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
        let sut = RecentActivitiesContainerViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        var activitiesArray: [ActivityItem] = []

        let randomDateOne = Date.arrangeRandomDateFromThisMonthNotToday
        let randomDateTwo = Date.arrangeRandomDateFromThisMonthNotToday
        let randomDateThree = Date.arrangeRandomDateFromThisMonthNotToday

        let activity = ActivityItem(context: coreData.viewContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
        activity.date = randomDateOne
        let activityTwo = ActivityItem(context: coreData.viewContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = randomDateTwo
        let activityThree = ActivityItem(context: coreData.viewContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com"
        activityThree.date = randomDateThree

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
        let sut = RecentActivitiesContainerViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        var activitiesArray:[ActivityItem] = []

        let activity = ActivityItem(context: coreData.viewContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
        activity.date = .arrange("14/04/2004")
        let activityTwo = ActivityItem(context: coreData.viewContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = .arrange("14/04/2016")
        let activityThree = ActivityItem(context: coreData.viewContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com"
        activityThree.date = .arrange("14/04/2017")

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)

        #expect(structure.todaysActivites.count == 0)
        #expect(structure.recentMonthActivities.count == 3)
        #expect(structure.currentMonthActivities.count == 0)
    }
}
