import Foundation
import XCTest
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class TopicDetailViewSnapshotTests: SnapshotTestCase {
    func test_topicDetail_light_fetching_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let sut = viewControllerBuilder.topicDetail(
            topic: MockDisplayableTopic(ref: "test_ref", title: "test_title"),
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_topicDetail_fetched_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(.arrange())
        let sut = viewControllerBuilder.topicDetail(
            topic: MockDisplayableTopic(ref: "test_ref", title: "test_title"),
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_topicDetail_fetched_manyStepBySteps_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(.arrangeLotsOfStepBySteps())
        let sut = viewControllerBuilder.topicDetail(
            topic: MockDisplayableTopic(ref: "test_ref", title: "test_title"),
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_topicDetail_dark_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(.arrangeLotsOfStepBySteps())
        let sut = viewControllerBuilder.topicDetail(
            topic: MockDisplayableTopic(ref: "test_ref", title: "test_title"),
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_topicDetail_onlySubTopics_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchTopicDetailsResult = .success(.arrangeOnlySubTopics())
        let sut = viewControllerBuilder.topicDetail(
            topic: TopicDetailResponse.Subtopic(ref: "test_ref", title: "test_title", description: "test_description"),
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
    
    func test_topicDetail_networkUnavailable_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchTopicDetailsResult = .failure(.networkUnavailable)
        let sut = viewControllerBuilder.topicDetail(
            topic: TopicDetailResponse.Subtopic(ref: "test_ref", title: "test_title", description: "test_description"),
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light
        )
    }
    
    func test_topicDetail_genericError_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchTopicDetailsResult = .failure(.apiUnavailable)
        let sut = viewControllerBuilder.topicDetail(
            topic: TopicDetailResponse.Subtopic(ref: "test_ref", title: "test_title", description: "test_description"),
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light
        )
    }

    func test_stepBySteps_light_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let sut = viewControllerBuilder.stepByStep(
            content: [
                .arrange(title: "content_1", description: "content_1", isStepByStep: true),
                .arrange(title: "content_2", description: "content_2", isStepByStep: true),
                .arrange(title: "content_3", description: "content_3", isStepByStep: true),
                .arrange(title: "content_4", description: "content_4", isStepByStep: true),
                .arrange(title: "content_5", description: "content_5", isStepByStep: true),
                .arrange(title: "content_6", description: "content_6", isStepByStep: true),
                .arrange(title: "content_7", description: "content_7", isStepByStep: true),
                .arrange(title: "content_8", description: "content_8", isStepByStep: true),
            ],
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            selectedAction: { _ in

            }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .light
        )
    }

    func test_stepBySteps_dark_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let sut = viewControllerBuilder.stepByStep(
            content: [
                .arrange(title: "content_1", description: "content_1", isStepByStep: true),
                .arrange(title: "content_2", description: "content_2", isStepByStep: true),
                .arrange(title: "content_3", description: "content_3", isStepByStep: true),
                .arrange(title: "content_4", description: "content_4", isStepByStep: true),
                .arrange(title: "content_5", description: "content_5", isStepByStep: true),
                .arrange(title: "content_6", description: "content_6", isStepByStep: true),
                .arrange(title: "content_7", description: "content_7", isStepByStep: true),
                .arrange(title: "content_8", description: "content_8", isStepByStep: true),
            ],
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            selectedAction: { _ in

            }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .dark
        )
    }
}
