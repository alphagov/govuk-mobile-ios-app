import UIKit
import Foundation

class RecentActivityViewModel: ObservableObject {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
    @Published var model: RecentActivitiesViewStructure
    @Published var selectedActivities = [String: ActivityItem]()
    private let urlOpener: URLOpener

    init(model: RecentActivitiesViewStructure,
         urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface) {
        self.model = model
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
    }

    func deleteActivities() {
        for activity in selectedActivities {
            guard let context = activity.value.managedObjectContext else { return }
            context.delete(activity.value)
        }
    }

    func navigateToBrowser(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    func isActivitySelected(id: String) -> Bool {
        return selectedActivities[id] != nil ? true : false
    }

    func selectAcvtivity(activity: ActivityItem) {
        if let savedActivities = selectedActivities[activity.id] {
            selectedActivities.removeValue(forKey: savedActivities.id)
        } else {
            selectedActivities[activity.id] = activity
        }
    }

    func selectAllActivties() {
        for item in model.todaysActivites {
            selectedActivities[item.id] = item
        }

        for item in model.currentMonthActivities {
            selectedActivities[item.id] = item
        }

        for (_, value) in model.recentMonthActivities {
            for activity in value {
                selectedActivities[activity.id] = activity
            }
        }
    }
}
