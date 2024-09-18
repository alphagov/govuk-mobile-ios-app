@testable import govuk_ios
import SwiftUI
import CoreData
import XCTest

final class RecentActivitiesViewModelTests: XCTestCase {
    var sut: RecentActivitiesViewModel?

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_sortActivities_whenActivitiesDateEqualsToday_populatesTodaysActivitesList() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

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

        let structure = sut?.sortActivites(activities: activitiesArray)

        XCTAssertEqual(structure?.todaysActivites.count, 3)
        XCTAssertEqual(structure?.recentMonthActivities.count, 0)
        XCTAssertEqual(structure?.currentMonthActivities.count, 0)
    }

    func test_sortItems_whenActivitesDateEqualsCurrentMomth_currentMonthsListIsPopulated() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        var activitiesArray: [ActivityItem] = []
        guard let randomDateOfCurrentMonthOne = generateRandomDateofCurrentMonth() else { return }
        guard let randomDateOfCurrentMonthTwo = generateRandomDateofCurrentMonth() else { return }
        guard let randomDateOfCurrentMonthThree = generateRandomDateofCurrentMonth() else { return }

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com/"
        activity.date = randomDateOfCurrentMonthOne
        let activityTwo = ActivityItem(context: coreData.backgroundContext)
        activityTwo.id = UUID().uuidString
        activityTwo.title = "universal credit2"
        activityTwo.url = "https://www.youtube.com/"
        activityTwo.date = randomDateOfCurrentMonthTwo
        let activityThree = ActivityItem(context: coreData.backgroundContext)
        activityThree.id = UUID().uuidString
        activityThree.title = "dvla2"
        activityThree.url = "https://www.youtube.com/"
        activityThree.date = randomDateOfCurrentMonthThree

        try? coreData.backgroundContext.save()

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut?.sortActivites(activities: activitiesArray)
        XCTAssertEqual(structure?.currentMonthActivities.count, 3)
        XCTAssertEqual(structure?.todaysActivites.count, 0)
        XCTAssertEqual(structure?.recentMonthActivities.count, 0)
    }

    func test_sortItems_whenActivitesDateEqualsRecentMonths_currentMonthsListIsPopulated() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        var activitiesArray:[ActivityItem] = []

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com/"
        activity.date = DateHelper.convertDateStringToDate(
            dateString: "2004-04-14T10:44:00+0000")
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

        activitiesArray.append(activity)
        activitiesArray.append(activityTwo)
        activitiesArray.append(activityThree)

        let structure = sut?.sortActivites(activities: activitiesArray)
        
        XCTAssertEqual(structure?.recentMonthActivities.count, 3)
        XCTAssertEqual(structure?.todaysActivites.count, 0)
        XCTAssertEqual(structure?.currentMonthActivities.count, 0)
    }

    private func generateRandomDateofCurrentMonth() -> Date? {
        let date = Date()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard
            let days = calendar.range(of: .day, in: .month, for: date),
            let randomDay = days.randomElement()
        else {
            return nil
        }
        dateComponents.setValue(randomDay, for: .day)
        return calendar.date(from: dateComponents)
    }
}

