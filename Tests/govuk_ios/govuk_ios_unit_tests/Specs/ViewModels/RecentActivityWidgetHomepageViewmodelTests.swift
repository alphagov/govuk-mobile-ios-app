import Foundation
import Testing
import Combine
import CoreData
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios
struct RecentActivityWidgetHomepageViewmodelTests {

    @Test
    func recentActivities_count_isLessOrEqualToThree() async throws {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockActivityService = MockActivityService()
            let sut = RecentActivtyHomepageWidgetViewModel(
                urlOpener: MockURLOpener(),
                analyticsService: MockAnalyticsService(),
                activityService: mockActivityService,
                seeAllAction: {}
            )

            let context = mockActivityService.returnContext()
            _ = ActivityItem.arrange(
                context: context
            )

            _ = ActivityItem.arrange(
                context: context
            )

            _ = ActivityItem.arrange(
                context: context
            )

            _ = ActivityItem.arrange(
                context: context
            )

            try? mockActivityService.returnContext().save()

            sut.$recentActivities
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                }.store(in: &cancellables)
        }
        #expect(result.count == 3)
    }


    @Test
    func isLastActivityInList_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockActivityService = MockActivityService()
            let sut = RecentActivtyHomepageWidgetViewModel(
                urlOpener: MockURLOpener(),
                analyticsService: MockAnalyticsService(),
                activityService: mockActivityService,
                seeAllAction: {}
            )

            let context = mockActivityService.returnContext()
            _ = ActivityItem.arrange(
                context: context
            )

            _ = ActivityItem.arrange(
                context: context
            )

            _ = ActivityItem.arrange(
                context: context
            )

            try? mockActivityService.returnContext().save()

            sut.$recentActivities
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    let isLastActivity = sut.isLastActivityInList(index: 2)

                    continuation.resume(returning: isLastActivity)
                }.store(in: &cancellables)
        }
        #expect(result == true)
    }
}

