import Foundation
import CoreData
import UIComponents
import GOVKit

class RecentActivtyHomepageWidgetViewModel: NSObject,
                                            ObservableObject,
                                            NSFetchedResultsControllerDelegate {
    @Published var recentActivities: [RecentActivityHomepageCell] = []
    private let activityService: ActivityServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    let seeAllAction: () -> Void

    private let fetchRequest = ActivityItem.homepagefetchRequest()
    private lazy var activitiesFetchResultsController: NSFetchedResultsController = {
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.activityService.returnContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()

    init(urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface,
         seeAllAction: @escaping () -> Void) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
        self.activityService = activityService
        self.seeAllAction = seeAllAction
        super.init()
        self.setupFetchResultsController()
    }

    let title: String = String.recentActivity.localized(
        "recentActivityNavigationTitle"
    )
    let emptyActivityStateTitle: String = String.recentActivity.localized(
        "emptyActivityStateTitle"
    )
    let seeAllButtonTitle: String = String.recentActivity.localized(
        "recentActivitySeeAllButtonTitle"
    )
    private func setupFetchResultsController() {
        try? activitiesFetchResultsController.performFetch()
        let activities = activitiesFetchResultsController.fetchedObjects ?? []
        recentActivities = mapRecentActivities(activities: activities)
    }

    func isLastActivityInList(index: Int) -> Bool {
        index == recentActivities.count - 1
    }

    private func mapRecentActivities(activities: [ActivityItem]) -> [RecentActivityHomepageCell] {
        activities
            .prefix(fetchRequest.fetchLimit)
            .map {
                RecentActivityHomepageCell(
                    title: $0.title,
                    lastVisitedString: lastVisitedString(activity: $0)
                )
            }
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            let activities =  activitiesFetchResultsController.fetchedObjects ?? []
            recentActivities = mapRecentActivities(activities: activities)
        }
}
