import Foundation
import UIKit
import SwiftUI
import CoreData

@testable import govuk_ios

class RecentActivityViewSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_errorView_rendersCorrectly() {
        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
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
            analyticsService: MockAnalyticsService()
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

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "benefits"
        activity.url = "https://www.youtube.com/"
        activity.date = Date.arrange("14/04/2016")

        try? coreData.backgroundContext.save()

        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
        )

        viewModel.sortActivites(activities: [activity])

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

        let activity = ActivityItem(context: coreData.backgroundContext)
        activity.id = UUID().uuidString
        activity.title = "Bringing your pet dog, cat or ferret to Great Britain, long title end"
        activity.url = "https://www.youtube.com/"
        activity.date = Date.arrange("14/04/2016")

        try? coreData.backgroundContext.save()

        let viewModel = RecentActivitiesViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService()
        )

        viewModel.sortActivites(activities: [activity])

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
