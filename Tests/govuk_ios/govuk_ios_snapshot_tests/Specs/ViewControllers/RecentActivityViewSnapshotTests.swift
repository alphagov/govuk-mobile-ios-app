import Foundation
import UIKit
import SwiftUI
import CoreData
import Factory

@testable import govuk_ios

class RecentActivityViewSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_errorView_rendersCorrectly() {
        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService()
        )

        let view = RecentActivityView(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_errorView_rendersCorrectly() {
        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService()
        )

        let view = RecentActivityView(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
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

        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        let view = RecentActivityView(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }

    func test_loadInNavigationController_light_rendersCorrectly() {
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


        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: activityService
        )

        let view = RecentActivityView(viewModel: viewModel)
        let viewController = HostingViewController(
            rootView: view
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }
}
