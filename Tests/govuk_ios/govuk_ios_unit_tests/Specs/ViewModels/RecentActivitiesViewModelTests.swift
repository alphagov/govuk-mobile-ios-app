import Testing
import Foundation
@testable import govuk_ios

struct RecentActivitiesViewModelTests {

    @Test
    func test_deleteActivities_deletesAllActivities() async throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")

        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/10/2024")

        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "benefits"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = Date.arrange("14/10/2024")

        try? coreData.backgroundContext.save()

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [activityOne],
            currentMonthActivities: [activityTwo],
            recentMonthActivities: [MonthGroupKey(date: Date()): [activityThree]]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
        )

        sut.deleteActivities()

        #expect(sut.model.todaysActivites == [])
        #expect(sut.model.currentMonthActivities == [])
        #expect(sut.model.recentMonthActivities == [:])

        for activity in sut.model.todaysActivites {
            #expect(activity.managedObjectContext == nil)
        }
        for activity in sut.model.currentMonthActivities {
            #expect(activity.managedObjectContext == nil)
        }
        for (_, activities) in sut.model.recentMonthActivities {
            for activity in activities {
                #expect(activity.managedObjectContext == nil)
            }
        }
    }

    @Test
    func test_buildSections_returnsCorrectSection() async throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")

        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/10/2024")

        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "benefits"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = Date.arrange("14/10/2024")

        try? coreData.backgroundContext.save()

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [activityOne],
            currentMonthActivities: [activityTwo],
            recentMonthActivities: [MonthGroupKey(date: Date()): [activityThree]]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
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
    func test_returnsActivityRow_returnsCorrectLinkRow() async throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")

        try? coreData.backgroundContext.save()

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [activityOne],
            recentMonthActivities: [:]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
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

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [activityOne],
            recentMonthActivities: [:]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
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

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [],
            recentMonthActivities: [:]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
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

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [],
            recentMonthActivities: [:]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
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

        let viewStructure = RecentActivitiesViewStructure(
            todaysActivites: [],
            currentMonthActivities: [],
            recentMonthActivities: [:]
        )
        let sut = RecentActivitiesViewModel(
            model: viewStructure,
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
