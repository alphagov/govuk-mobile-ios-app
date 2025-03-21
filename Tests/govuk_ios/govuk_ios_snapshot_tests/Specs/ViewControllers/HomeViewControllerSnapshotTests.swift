import Foundation
import XCTest
import UIKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

@MainActor
class HomeViewControllerSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()

    //    func test_loadInNavigationController_light_rendersCorrectly() {
    //        mockTopicService._stubbedHasCustomisedTopics = true
    //        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
    //        var topics = Topic.arrangeMultipleFavourites(
    //            context: coreData.viewContext
    //        )
    //
    //        mockTopicService._stubbedFetchAllTopics = topics
    //
    //        topics.removeLast()
    //        mockTopicService._stubbedFetchFavouriteTopics = topics
    //        let viewController = viewController()
    //
    //        let window = UIApplication.shared.window
    //        guard let window = window else { return }
    //        window.rootViewController = viewController
    //
    //        viewController.viewDidLoad()
    //
    //
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController,
    //            mode: .light,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func test_loadInNavigationController_dark_rendersCorrectly() {
    //        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
    //        let topics = Topic.arrangeMultipleFavourites(
    //            context: coreData.viewContext
    //        )
    //        mockTopicService._stubbedFetchAllTopics = topics
    //        mockTopicService._stubbedFetchFavouriteTopics = topics
    //
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController(),
    //            mode: .dark,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func test_loadInNavigationController_notCusomised_rendersCorrectly() {
    //        mockTopicService._stubbedHasCustomisedTopics = false
    //        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
    //        var topics = Topic.arrangeMultipleFavourites(
    //            context: coreData.viewContext
    //        )
    //
    //        mockTopicService._stubbedFetchAllTopics = topics
    //
    //        topics.removeLast()
    //        mockTopicService._stubbedFetchFavouriteTopics = topics
    //
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController(),
    //            mode: .light,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func test_loadInNavigationController_topicsError_rendersCorrectly() {
    //        mockTopicService._stubbedHasCustomisedTopics = false
    //        mockTopicService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController(),
    //            mode: .light,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func test_loadInNavigationController_topicsError_dark_rendersCorrectly() {
    //        mockTopicService._stubbedHasCustomisedTopics = false
    //        mockTopicService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController(),
    //            mode: .dark,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func test_loadInNavigationController_deselectedAllTopics_rendersCorrectly() {
    //        let topics = Topic.arrangeMultipleFavourites(
    //            context: coreData.viewContext
    //        )
    //        mockTopicService._stubbedFetchAllTopics = topics
    //        mockTopicService._stubbedHasCustomisedTopics = true
    //        mockTopicService._stubbedFetchFavouriteTopics = []
    //        mockTopicService._stubbedFetchRemoteListResult = .success([])
    //
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController(),
    //            mode: .light,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func test_loadInNavigationController_deselectedAllTopics_dark_rendersCorrectly() {
    //        let topics = Topic.arrangeMultipleFavourites(
    //            context: coreData.viewContext
    //        )
    //        mockTopicService._stubbedFetchAllTopics = topics
    //        mockTopicService._stubbedHasCustomisedTopics = true
    //        mockTopicService._stubbedFetchFavouriteTopics = []
    //        mockTopicService._stubbedFetchRemoteListResult = .success([])
    //
    //        VerifySnapshotInNavigationController(
    //            viewController: viewController(),
    //            mode: .dark,
    //            navBarHidden: true
    //        )
    //    }
    //
    //    func viewController() -> HomeViewController {
    //        let topicsViewModel = TopicsWidgetViewModel(
    //            topicsService: mockTopicService,
    //            analyticsService: mockAnalyticsService,
    //            topicAction: { _ in },
    //            editAction: { },
    //            allTopicsAction: { }
    //        )
    //        let mockNotificationService = MockNotificationService()
    //        mockNotificationService._stubbedShouldRequestPermission = true
    //        let viewModel = HomeViewModel(
    //            analyticsService: MockAnalyticsService(),
    //            configService: MockAppConfigService(),
    //            notificationService: mockNotificationService,
    //            topicWidgetViewModel: topicsViewModel,
    //            feedbackAction: { },
    //            searchAction: { },
    //            notificationsAction: { },
    //            recentActivityAction: { }
    //        )
    //        let vc = HomeViewController(viewModel: viewModel)
    //        return vc
    //    }

//    func test_loadInNavigationController_light_rendersCorrectly() {
//        mockTopicService._stubbedHasCustomisedTopics = true
//        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
//        var topics = Topic.arrangeMultipleFavourites(
//            context: coreData.viewContext
//        )
//
//        mockTopicService._stubbedFetchAllTopics = topics
//
//        topics.removeLast()
//        mockTopicService._stubbedFetchFavouriteTopics = topics
//
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .light,
//            navBarHidden: true
//        )
//    }
//
//    func test_loadInNavigationController_dark_rendersCorrectly() {
//        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
//        let topics = Topic.arrangeMultipleFavourites(
//            context: coreData.viewContext
//        )
//        mockTopicService._stubbedFetchAllTopics = topics
//        mockTopicService._stubbedFetchFavouriteTopics = topics
//
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .dark,
//            navBarHidden: true
//        )
//    }
//
//    func test_loadInNavigationController_notCusomised_rendersCorrectly() {
//        mockTopicService._stubbedHasCustomisedTopics = false
//        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
//        var topics = Topic.arrangeMultipleFavourites(
//            context: coreData.viewContext
//        )
//
//        mockTopicService._stubbedFetchAllTopics = topics
//
//        topics.removeLast()
//        mockTopicService._stubbedFetchFavouriteTopics = topics
//
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .light,
//            navBarHidden: true
//        )
//    }
//
//    func test_loadInNavigationController_topicsError_rendersCorrectly() {
//        mockTopicService._stubbedHasCustomisedTopics = false
//        mockTopicService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .light,
//            navBarHidden: true
//        )
//    }
//
//    func test_loadInNavigationController_topicsError_dark_rendersCorrectly() {
//        mockTopicService._stubbedHasCustomisedTopics = false
//        mockTopicService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .dark,
//            navBarHidden: true
//        )
//    }
//
//    func test_loadInNavigationController_deselectedAllTopics_rendersCorrectly() {
//        let topics = Topic.arrangeMultipleFavourites(
//            context: coreData.viewContext
//        )
//        mockTopicService._stubbedFetchAllTopics = topics
//        mockTopicService._stubbedHasCustomisedTopics = true
//        mockTopicService._stubbedFetchFavouriteTopics = []
//        mockTopicService._stubbedFetchRemoteListResult = .success([])
//
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .light,
//            navBarHidden: true
//        )
//    }
//
//    func test_loadInNavigationController_deselectedAllTopics_dark_rendersCorrectly() {
//        let topics = Topic.arrangeMultipleFavourites(
//            context: coreData.viewContext
//        )
//        mockTopicService._stubbedFetchAllTopics = topics
//        mockTopicService._stubbedHasCustomisedTopics = true
//        mockTopicService._stubbedFetchFavouriteTopics = []
//        mockTopicService._stubbedFetchRemoteListResult = .success([])
//
//        VerifySnapshotInNavigationController(
//            viewController: viewController(),
//            mode: .dark,
//            navBarHidden: true
//        )
//    }
//
//    func viewController() -> HomeViewController {
//        let topicsViewModel = TopicsWidgetViewModel(
//            topicsService: mockTopicService,
//            analyticsService: mockAnalyticsService,
//            topicAction: { _ in },
//            editAction: { },
//            allTopicsAction: { }
//        )
//        let mockNotificationService = MockNotificationService()
//        mockNotificationService._stubbedShouldRequestPermission = true
//        let viewModel = HomeViewModel(
//            analyticsService: MockAnalyticsService(),
//            configService: MockAppConfigService(),
//            notificationService: mockNotificationService,
//            topicWidgetViewModel: topicsViewModel,
//            feedbackAction: { },
//            notificationsAction: { },
//            recentActivityAction: { },
//            urlOpener: MockURLOpener()
//        )
//        return HomeViewController(viewModel: viewModel)
//    }
}
