import Foundation
import Testing
import Combine
import CoreData
@testable import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios
struct RecentActivtyHomepageWidgetViewModelTests {

    @Test
    func recentActivities_count_isLessOrEqualToThree() async throws {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockActivityService = MockActivityService()
            let sut = RecentActivityHomepageWidgetViewModel(
                analyticsService: MockAnalyticsService(),
                activityService: mockActivityService,
                seeAllAction: {},
                openURLAction: { _ in }
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

            sut.$sections
                .receive(on: DispatchQueue.main)
                .sink { value in
                    continuation.resume(returning: value)
                }.store(in: &cancellables)
        }
        #expect(result[0].rows.count == 3)
    }
}

