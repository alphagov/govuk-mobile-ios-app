import UIKit
import CoreData
import SwiftUICore
import Foundation

class RecentActivitiesViewModel: ObservableObject {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
    var model: RecentActivitiesViewStructure
    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited
    private let urlOpener: URLOpener

    init(model: RecentActivitiesViewStructure,
         urlOpener: URLOpener) {
        self.model = model
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
    }

    func deleteActivities() {
        for item in model.todaysActivites {
            let context = item.managedObjectContext
            context?.delete(item)
            try? context?.save()
        }
        for item in model.currentMonthActivities {
            let context = item.managedObjectContext
            context?.delete(item)
            try? context?.save()
        }
        for (_, activities) in model.recentMonthActivities {
            for activity in activities {
                let context = activity.managedObjectContext
                context?.delete(activity)
                try? context?.save()
            }
        }
        model.todaysActivites.removeAll()
        model.currentMonthActivities.removeAll()
        model.todaysActivites.removeAll()
    }

    func buildSectionsView() -> [GroupedListSection] {
        model.recentMonthActivities.keys
            .sorted { $0 > $1 }
            .map {
                let items = model.recentMonthActivities[$0]
                return GroupedListSection(
                    heading: $0.title,
                    rows: items?.map(activityRow) ?? [],
                    footer: nil
                )
            }
    }

    private func navigateToBrowser(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    func activityRow(activityItem: ActivityItem) -> LinkRow {
        LinkRow(
            id: activityItem.id,
            title: activityItem.title,
            body: lastVisitedString(activity: activityItem),
            action: {
                self.navigateToBrowser(item: activityItem)
            }
        )
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }

    private func trackSelection(activity: ActivityItem) {
        let event = AppEvent.recentActivity(
            activity: activity.title
        )
        analyticsService.track(
            event: event
        )
    }
}
