import Foundation
import XCTest

@testable import govuk_ios

final class RecentActivitiesViewModelTestsXC: XCTestCase {
    
    var sut: RecentActivitiesViewModel!
    var coreData: CoreDataRepository!
    var mockAnalyticsService: MockAnalyticsService!
    var mockURLOpener: MockURLOpener!
    
    override func setUp() {
        coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()
        mockAnalyticsService = MockAnalyticsService()
        mockURLOpener = MockURLOpener()
        sut = RecentActivitiesViewModel(
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener
        )
    }
    
    override func tearDown() {
        coreData = nil
        sut = nil
        mockAnalyticsService = nil
        mockURLOpener = nil
        super.tearDown()
    }
    
    func test_sortActivities_whenActivitiesDateEqualsToday_populatesTodaysActivitesList() throws {
        var activitiesArray: [ActivityItem] = []
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefits"
        activity.url = "https://www.youtube.com"
        activity.date = Date()
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = Date()
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com"
        activityThree.date = Date()

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)

        XCTAssertEqual(structure.todaysActivites.count, 3)
        XCTAssertEqual(structure.recentMonthActivities.count, 0)
        XCTAssertEqual(structure.currentMonthActivities.count, 0)
    }

    func sortItems_whenActivitesDateEqualsCurrentMonth_currentMonthsListIsPopulated() throws {
        var activitiesArray: [ActivityItem] = []

        let randomDateOne = Date.arrangeRandomDateFromThisMonthNotToday
        let randomDateTwo = Date.arrangeRandomDateFromThisMonthNotToday
        let randomDateThree = Date.arrangeRandomDateFromThisMonthNotToday

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
        activity.date = randomDateOne
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = randomDateTwo
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com"
        activityThree.date = randomDateThree

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)
        XCTAssertEqual(structure.todaysActivites.count, 0)
        XCTAssertEqual(structure.recentMonthActivities.count, 0)
        XCTAssertEqual(structure.currentMonthActivities.count, 3)
    }
    
    func test_sortItems_whenActivitesDateEqualsRecentMonths_currentMonthsListIsPopulated() throws {
        var activitiesArray:[ActivityItem] = []

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
        activity.date = .arrange("14/04/2004")
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com"
        activityTwo.date = .arrange("14/04/2016")
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com"
        activityThree.date = .arrange("14/04/2017")

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut.sortActivites(activities: activitiesArray)

        XCTAssertEqual(structure.todaysActivites.count, 0)
        XCTAssertEqual(structure.recentMonthActivities.count, 3)
        XCTAssertEqual(structure.currentMonthActivities.count, 0)
    }
    
    func test_selected_withLink_tracksEvent() {
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.title = "Benefits"
        activity.url = "https://www.youtube.com"
        try? coreData.backgroundContext.save()
        sut.selected(item: activity)

        XCTAssertEqual(mockAnalyticsService._trackedEvents.count, 1)
        XCTAssertEqual(mockAnalyticsService._trackedEvents.first?.name, "RecentActivity")
    }
    
    func test_selected_noLink_doesntTracksEvent() {
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.title = "Benefits"
        try? coreData.backgroundContext.save()
        sut.selected(item: activity)

        XCTAssertEqual(mockAnalyticsService._trackedEvents.count, 0)
    }
    
    func test_selected_updatesItemDate() {
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
        let oldDate = Date.arrange("14/04/2004")
        activity.date = oldDate

        try? coreData.backgroundContext.save()

        sut.selected(item: activity)

        let equal = Calendar.current.isDate(
            activity.date,
            equalTo: Date(),
            toGranularity: .second
        )
        XCTAssertTrue(equal)
        XCTAssertNotEqual(activity.date, oldDate)
    }
    
    func test_selected_withURL_opensURL() {
        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        let expectedURL = "https://www.youtube.com"
        activity.url = expectedURL
        let oldDate = Date.arrange("14/04/2004")
        activity.date = oldDate

        try? coreData.backgroundContext.save()

        sut.selected(item: activity)

        XCTAssertEqual(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString, expectedURL)
    }

}

