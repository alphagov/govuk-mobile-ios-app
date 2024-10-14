import SwiftUI
import CoreData
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct RecentActivitiesViewModelTests {

    @Test
    func sortActivities_whenActivitiesDateEqualsToday_populatesTodaysActivitesList() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
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

        sut.sortActivites(activities: activitiesArray)

        #expect(sut.model.todaysActivites.count == 3)
        #expect(sut.model.recentMonthActivities.count == 0)
        #expect(sut.model.currentMonthActivities.count == 0)
    }

    @Test
    func sortItems_whenActivitesDateEqualsCurrentMonth_currentMonthsListIsPopulated() throws {

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
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

        sut.sortActivites(activities: activitiesArray)

        #expect(sut.model.todaysActivites.count == 0)
        #expect(sut.model.recentMonthActivities.count == 0)
        #expect(sut.model.currentMonthActivities.count == 3)
    }

    @Test
    func sortItems_whenActivitesDateEqualsRecentMonths_currentMonthsListIsPopulated() throws {
        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
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

        sut.sortActivites(activities: activitiesArray)

        #expect(sut.model.todaysActivites.count == 0)
        #expect(sut.model.recentMonthActivities.count == 3)
        #expect(sut.model.currentMonthActivities.count == 0)
    }

    @Test
    func buildSections_returnsCorrectSection() async throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo .id = UUID().uuidString
        activityTwo .title = "benefits"
        activityTwo .url = "https://www.youtube.com/"
        activityTwo .date = Date.arrange("14/10/2024")
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "benefits"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = Date.arrange("14/10/2024")

        try? coreData.backgroundContext.save()

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
        )
        let groupSections = sut.buildSections()

        guard let sectionHeader: String = groupSections.first?.heading
        else { return }
        guard let sectionRowTitle: String = groupSections.first?.rows.first?.body
        else { return }

        #expect(sut.buildSections().count == 1)
        #expect(sectionHeader == "October 2024")
        #expect(sectionRowTitle == "Last visited on 14 October")
    }

    @Test
    func returnsActivityRow_returnsCorrectLinkRow() async throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")

        try? coreData.backgroundContext.save()

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
        )

        let activityRow = sut.returnActivityRow(activityItem: activityOne)

        #expect(activityRow.title == "benefits")
        #expect(activityRow.body == "Last visited on 14 April")
        #expect(activityRow.isWebLink == true)
    }

    @Test
    func returnActivityRow_withLink_tracksEvent() {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let mockAnalyticsService = MockAnalyticsService()

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")

        let activityTwo = ActivityItem(context: coreData.viewContext)
        activityTwo.title = "Benefits"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = Date.arrange("15/04/2016")

        try? coreData.backgroundContext.save()

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: mockAnalyticsService
        )

        let activityRow = sut.returnActivityRow(activityItem: activityTwo)
        activityRow.action()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "RecentActivity")
    }

    @Test
    func returnActivityRow_action_noLink_doesntTracksEvent() {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: mockAnalyticsService
        )

        let activity = ActivityItem(context: coreData.viewContext)
        activity.title = "Benefits"
        activity.date = Date.arrange("15/04/2016")

        let activityRow = sut.returnActivityRow(activityItem: activity)
        activityRow.action()

        #expect(mockAnalyticsService._trackedEvents.count == 0)
    }

    @Test
    func returnActivityRow_action_updatesItemDate() {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
        )

        let activity = ActivityItem(context: coreData.viewContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
        let oldDate = Date.arrange("14/04/2004")
        activity.date = oldDate

        let activityRow = sut.returnActivityRow(activityItem: activity)
        activityRow.action()

        let equal = Calendar.current.isDate(
            activity.date,
            equalTo: Date(),
            toGranularity: .second
        )
        #expect(equal)
        #expect(activity.date != oldDate)
    }

    @Test
    func returnActivityRow_action_withURL_opensURL() {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let mockURLOpener = MockURLOpener()

        let sut = RecentActivitiesViewModel(
            urlOpener: mockURLOpener,
            analyticsService: MockAnalyticsService()
        )

        let activity = ActivityItem(context: coreData.viewContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        let expectedURL = "https://www.youtube.com"
        activity.url = expectedURL
        let oldDate = Date.arrange("14/04/2004")
        activity.date = oldDate

        let activityRow = sut.returnActivityRow(activityItem: activity)
        activityRow.action()

        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == expectedURL)
    }
}
