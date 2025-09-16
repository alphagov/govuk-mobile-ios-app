import SwiftUI
import CoreData
import GOVKit

struct RecentActivityWidget: View {
    @StateObject var viewModel: RecentActivtyWidgetViewModel
    var body: some View {
        VStack {
        HStack {
            Text("Pages youve visited")
            Spacer()
            Text("See All")
        }.padding(.horizontal)
        VStack {
            ForEach(0..<viewModel.recentActivities.count, id: \.self) { index in
                RecentActivityItemCard(
                    model: viewModel.recentActivities[index],
                    postitionInList: index
                ).padding([.horizontal, .top])
            }
        }.roundedBorder(borderColor: .cyan)
            .padding(.horizontal)
            .padding(.top, 8)
        }.padding(.bottom, 8)
    }
}

struct RecentActivityItemCard: View {
    let model: CardModels
    let postitionInList: Int
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.title)
                    .multilineTextAlignment(.leading)
                Text(model.lastVisitedString)
                    .padding([.bottom], postitionInList >= 2 ? 12 : 0)
                if postitionInList < 2 {
                    Divider()
                }
            }
            Spacer()
        }
    }
}


class RecentActivtyWidgetViewModel: NSObject,
                                    ObservableObject,
                                    NSFetchedResultsControllerDelegate {
    @Published var recentActivities: [CardModels] = []
    private let activityService: ActivityServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let lastVisitedFormatter = DateFormatter.recentActivityLastVisited

    init(urlOpener: URLOpener,
         analyticsService: AnalyticsServiceInterface,
         activityService: ActivityServiceInterface) {
        self.urlOpener = urlOpener
        self.analyticsService = analyticsService
        self.activityService = activityService
        super.init()
        self.setupFetchResultsController()
    }

    private func setupFetchResultsController() {
        fetchActivities.delegate = self
        try? fetchActivities.performFetch()
        let activities = fetchActivities.fetchedObjects ?? []
        self.recentActivities = mapRecentActivities(activities: activities)
        print(recentActivities.count)
    }

    private func mapRecentActivities(activities: [ActivityItem]) -> [CardModels] {
        var recentActivities = activities.map {
            CardModels(title: $0.title, lastVisitedString: lastVisitedString(activity: $0))
        }
        for (index, value) in recentActivities.enumerated() where index > 2 {
            recentActivities.remove(at: index)
        }
        return recentActivities
    }

    private func lastVisitedString(activity: ActivityItem) -> String {
        let copy = String.recentActivity.localized(
            "recentActivityFormattedDateStringComponent"
        )
        let formattedDateString = lastVisitedFormatter.string(from: activity.date)
        return "\(copy) \(formattedDateString)"
    }

    lazy var fetchActivities: NSFetchedResultsController = {
        var controller = NSFetchedResultsController(
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
            self.recentActivities = mapRecentActivities(activities: activities)
        }
}
struct CardModels {
    let title: String
    let lastVisitedString: String
}
