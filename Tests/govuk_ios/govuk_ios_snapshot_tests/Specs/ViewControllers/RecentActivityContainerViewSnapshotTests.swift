import Foundation
import UIKit
import SwiftUI
import CoreData

@testable import govuk_ios

class RecentActivityContainerViewSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_errorView_rendersCorrectly() {
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let viewModel = RecentActivitiesViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )

        let view = RecentActivityContainerView(viewModel: viewModel)
            .environment(
                \.managedObjectContext,
                 coreData.viewContext
            )
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
        let coreData = CoreDataRepository.arrange(
            notificationCenter: .default
        ).load()

        let viewModel = RecentActivitiesViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )
        let view = RecentActivityContainerView(viewModel: viewModel)
            .environment(
                \.managedObjectContext,
                 coreData.viewContext
            )
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
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )
        let view = RecentActivityContainerView(viewModel: viewModel)
            .environment(
            \.managedObjectContext,
             coreData.viewContext
        )
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
            analyticsService: MockAnalyticsService(),
            urlOpener: UIApplication.shared
        )
        let view = RecentActivityContainerView(viewModel: viewModel)
            .environment(
                \.managedObjectContext,
                 coreData.viewContext
            )

        let viewController = HostingViewController(
            rootView: view
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }
}