import SwiftUI
import CoreData
import Testing
import Factory

@testable import govuk_ios

@Suite
@MainActor
struct RecentActivitiesViewModelTests {

    @Test
    func sortActivities_whenActivitiesDateEqualsToday_populatesTodaysActivitesList() throws {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

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

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        #expect(sut.model.todaysActivites.count == 3)
        #expect(sut.model.recentMonthActivities.count == 0)
        #expect(sut.model.currentMonthActivities.count == 0)
    }

    @Test
    func sortActivities_whenActivitesDateEqualsCurrentMonth_currentMonthsListIsPopulated() throws {

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

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

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        #expect(sut.model.todaysActivites.count == 0)
        #expect(sut.model.recentMonthActivities.count == 0)
        #expect(sut.model.currentMonthActivities.count == 3)
    }

    @Test
    func sortActivities_whenActivitesDateEqualsRecentMonths_recentMonthsListIsPopulated() throws {

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

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

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        #expect(sut.model.todaysActivites.count == 0)
        #expect(sut.model.recentMonthActivities.count == 3)
        #expect(sut.model.currentMonthActivities.count == 0)
    }

    @Test
    func buildSections_returnsCorrectSection() async throws {

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

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

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        let groupSections = sut.buildSections()

        guard let sectionHeader: String = groupSections.first?.heading
        else { return }
        guard let sectionRowTitle: String = groupSections.first?.rows.first?.body
        else { return }

        #expect(sut.buildSections().count == 1)
        #expect(sectionHeader == "April 2016")
        #expect(sectionRowTitle == "Last visited on 14 April")
    }

    @Test
    func returnsActivityRow_returnsCorrectLinkRow() async throws {

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

        let activityOne = ActivityItem(context: coreData.backgroundContext)
        activityOne.id = UUID().uuidString
        activityOne.title = "benefits"
        activityOne.url = "https://www.youtube.com/"
        activityOne.date = Date.arrange("14/04/2016")

        try? coreData.backgroundContext.save()

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
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

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

        let mockAnalyticsService = MockAnalyticsService()

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.title = "Benefits"
        activity.url = "https://www.youtube.com"
        activity.date = Date.arrange("15/04/2016")

        try? coreData.backgroundContext.save()

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: mockAnalyticsService,
            activityService: activityService
        )

        let activityRow = sut.returnActivityRow(activityItem: activity)
        activityRow.action()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.name == "RecentActivity")
    }

    @Test
    func returnActivityRow_action_noLink_doesntTracksEvent() {

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

        let mockAnalyticsService = MockAnalyticsService()

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.title = "Benefits"
        activity.date = Date.arrange("15/04/2016")

        try? coreData.backgroundContext.save()

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: mockAnalyticsService,
            activityService: activityService
        )

        let activityRow = sut.returnActivityRow(activityItem: activity)
        activityRow.action()

        #expect(mockAnalyticsService._trackedEvents.count == 0)
    }

    @Test
    func returnActivityRow_action_updatesItemDate() {

        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        activity.url = "https://www.youtube.com"
         
        let oldDate = Date.arrange("14/04/2004")
        activity.date = oldDate

        try? coreData.backgroundContext.save()

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

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

        let activityService = MockActivityService()
        Container.shared.activityService.register { MockActivityService() }

        let mockURLOpener = MockURLOpener()

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefit3"
        let expectedURL = "https://www.youtube.com"
        activity.url = expectedURL
        let oldDate = Date.arrange("14/04/2004")
        activity.date = oldDate

        try? coreData.backgroundContext.save()

        let controller = NSFetchedResultsController<ActivityItem>(
            fetchRequest: ActivityItem.fetchRequest(),
            managedObjectContext: coreData.backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        ).fetch()

        activityService._stubbedResultsController = controller

        let sut = RecentActivitiesViewModel(
            urlOpener: mockURLOpener,
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        let activityRow = sut.returnActivityRow(activityItem: activity)
        activityRow.action()

        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == expectedURL)
    }
}
