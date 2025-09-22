import Foundation
import Testing
import Combine
import CoreData
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios
struct RecentActivityWidgetHomepageViewmodelTests {
 //   private var cancellables = Set<AnyCancellable>()

    @Test func ___() async throws {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockActivityService = MockActivityService()

            let sut = RecentActivtyHomepageWidgetViewModel(
                urlOpener: MockURLOpener(),
                analyticsService: MockAnalyticsService(),
                activityService: mockActivityService,
                seeAllAction: {}
            )
            let coreData = CoreDataRepository.arrangeAndLoad
            _ = ActivityItem.arrange(
                context: coreData.viewContext
            )

            _ = ActivityItem.arrange(
                context: coreData.viewContext
            )

            try? coreData.viewContext.save()

        
            let request = ActivityItem.homepagefetchRequest()
            let resultsController = NSFetchedResultsController<ActivityItem>(
                fetchRequest: request,
                managedObjectContext: coreData.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            try? resultsController.performFetch()
            mockActivityService._stubbedFetchResultsController = resultsController

            sut.$recentActivities
                .receive(on: DispatchQueue.main)
                .dropFirst()
                .sink { value in
                    continuation.resume(returning: value)
                }.store(in: &cancellables)
        }
            #expect(result.count == 2)
        }

    @Test func noActivityTitle_returnsExpectedResult() async throws {
        let sut = RecentActivtyHomepageWidgetViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            seeAllAction: {}
        )
    }

    @Test func recentActivities_hasEqualOrLessThan3Activities() async throws {
        let sut = RecentActivtyHomepageWidgetViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            seeAllAction: {}
        )
    }
}

