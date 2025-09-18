import SwiftUI
import CoreData
import GOVKit

struct RecentActivityWidget: View {
    @ObservedObject var viewModel: RecentActivtyWidgetViewModel
    var body: some View {
        if viewModel.recentActivities.isEmpty {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(Font.govUK.title3Semibold)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .padding(.horizontal)
                NonTappableCardView(
                    text: viewModel.emptyActivityStateTitle
                )
            }
        } else {
            VStack {
                HStack {
                    Text(viewModel.title)
                        .font(Font.govUK.title3Semibold)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                    Spacer()
                    Button(
                        action: {
                            viewModel.seeAllAction()
                        }, label: {
                            Text(viewModel.seeAllButtonTitle)
                                .foregroundColor(Color(UIColor.govUK.text.link))
                                .font(Font.govUK.subheadlineSemibold)
                        }
                    )
                }.padding(.horizontal)
                VStack {
                    ForEach(0..<viewModel.recentActivities.count, id: \.self) { index in
                        RecentActivityItemCard(
                            model: viewModel.recentActivities[index],
                            postitionInList: index,
                            isLastItemInList: viewModel.isLastActivityInList(
                                index: index
                            )
                        ).padding([.horizontal])
                            .padding([.top], index == 0 ? 8: 0)
                    }
                }.background(Color(uiColor: UIColor.govUK.fills.surfaceList))
                    .roundedBorder(borderColor: .clear)
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
        }
    }
}

struct RecentActivityItemCard: View {
    let model: RecentActivityHomepageCell
    let postitionInList: Int
    let isLastItemInList: Bool

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(model.title)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                        .multilineTextAlignment(.leading)
                    Text(model.lastVisitedString)
                        .font(Font.govUK.subheadline)
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                        .multilineTextAlignment(.leading)
                }.padding(.bottom, isLastItemInList ? 12: 0)
                Spacer()
            }.padding(.vertical, 8)
            if !isLastItemInList {
                Divider().overlay(Color.cyan)
            }
        }.background(Color(uiColor: UIColor.govUK.fills.surfaceList))
    }
}
class RecentActivtyWidgetViewModel: NSObject,
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
        self.recentActivities = mapRecentActivities(activities: activities)
    }

    func isLastActivityInList(index: Int) -> Bool {
        return index == recentActivities.count - 1
    }

    private func mapRecentActivities(activities: [ActivityItem]) -> [RecentActivityHomepageCell] {
        var recentActivities = activities.map {
            RecentActivityHomepageCell(
                title: $0.title,
                lastVisitedString: lastVisitedString(activity: $0)
            )
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
struct RecentActivityHomepageCell {
    let title: String
    let lastVisitedString: String
}
