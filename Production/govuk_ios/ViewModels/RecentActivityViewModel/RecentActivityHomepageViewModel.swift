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
        fetchActivities.delegate = self
        try? fetchActivities.performFetch()
        let activities = fetchActivities.fetchedObjects ?? []
        recentActivities = mapRecentActivities(activities: activities)
    }

    func isLastActivityInList(index: Int) -> Bool {
        return index == recentActivities.count - 1
    }

    private func mapRecentActivities(activities: [ActivityItem]) -> [RecentActivityHomepageCell] {
        var mappedActivities = activities.map {
            RecentActivityHomepageCell(
                title: $0.title,
                lastVisitedString: lastVisitedString(activity: $0)
            )
        }
        for (index, value) in mappedActivities.enumerated() where index > 2 {
            mappedActivities.remove(at: index)
        }
        return mappedActivities
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }

    lazy var fetchActivities: NSFetchedResultsController = {
        let controller = NSFetchedResultsController(
            fetchRequest: ActivityItem.homepagefetchRequest(),
            managedObjectContext: self.activityService.returnContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return controller
    }()

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            let activities =  fetchActivities.fetchedObjects ?? []
            recentActivities = mapRecentActivities(activities: activities)
        }
}
