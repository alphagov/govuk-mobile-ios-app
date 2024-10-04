import UIKit
import Foundation

class RecentActivityViewModel: ObservableObject {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
    @Published var model: RecentActivitiesViewStructure
    @Published var selectedActivities = [String: ActivityItem]()
    private let urlOpener: URLOpener

    init(model: RecentActivitiesViewStructure,
         urlOpener: URLOpener) {
        self.model = model
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
    }

    func deleteActivities() {
        guard let context = selectedActivities.first?.value.managedObjectContext
        else { return }
        for activity in selectedActivities {
            context.delete(activity.value)
        }
        try? context.save()
        selectedActivities.removeAll()
    }

    func navigateToBrowser(item: ActivityItem) {
        item.date = Date()
        try? item.managedObjectContext?.save()
        guard let url = URL(string: item.url) else { return }
        urlOpener.openIfPossible(url)
        trackSelection(activity: item)
    }

    func isActivitySelected(id: String) -> Bool {
        return selectedActivities[id] != nil
    }

    private func trackSelection(activity: ActivityItem) {
        let event = AppEvent.recentActivity(
            activity: activity.title
        )
        analyticsService.track(
            event: event
        )
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
