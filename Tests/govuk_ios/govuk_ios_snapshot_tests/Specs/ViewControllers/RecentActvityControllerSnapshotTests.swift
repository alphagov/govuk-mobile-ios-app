import Foundation
import UIKit
import SwiftUI
import CoreData
@testable import govuk_ios

class RecentActvitySnapshots: SnapshotTestCase {

    func test_loadInNavigationController_light_errorView_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: returnViewController(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_errorView_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: returnViewController(),
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
        activity.date = DateHelper.convertDateStringToDate(
            dateString: "2016-04-14T10:44:00+0000")

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
       let viewController =  UIHostingController(rootView: view)

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
        activity.title = "benefits"
        activity.url = "https://www.youtube.com/"
        activity.date = DateHelper.convertDateStringToDate(
            dateString: "2016-04-14T10:44:00+0000")

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
        let viewController =  UIHostingController(rootView: view)

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    private func returnViewController() -> UIViewController {
        let viewModel = RecentActivitiesViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )

        let view = RecentActivityContainerView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }
}

