import UIKit
import CoreData
import SwiftUICore
import Foundation

class RecentActivityViewModel: ObservableObject {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
    var model: RecentActivitiesViewStructure
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

    func navigateToBrowser(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
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
