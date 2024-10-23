import Foundation
import XCTest
import UIKit

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
            stepByStepAction: { _ in }
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
            stepByStepAction: { _ in }
        )
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
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
            stepByStepAction: { _ in }
        )
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
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
            stepByStepAction: { _ in }
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_stepBySteps_light_rendersCorrectly() {
        let viewControllerBuilder = ViewControllerBuilder()
        let sut = viewControllerBuilder.stepByStep(
            content: [
                .init(description: "content_1", isStepByStep: true, popular: false, title: "content_1", url: .arrange),
                .init(description: "content_2", isStepByStep: true, popular: false, title: "content_2", url: .arrange),
                .init(description: "content_3", isStepByStep: true, popular: false, title: "content_3", url: .arrange),
                .init(description: "content_4", isStepByStep: true, popular: false, title: "content_4", url: .arrange),
                .init(description: "content_5", isStepByStep: true, popular: false, title: "content_5", url: .arrange),
                .init(description: "content_6", isStepByStep: true, popular: false, title: "content_6", url: .arrange),
                .init(description: "content_7", isStepByStep: true, popular: false, title: "content_7", url: .arrange),
                .init(description: "content_8", isStepByStep: true, popular: false, title: "content_8", url: .arrange),
            ],
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService()
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
                .init(description: "content_1", isStepByStep: true, popular: false, title: "content_1", url: .arrange),
                .init(description: "content_2", isStepByStep: true, popular: false, title: "content_2", url: .arrange),
                .init(description: "content_3", isStepByStep: true, popular: false, title: "content_3", url: .arrange),
                .init(description: "content_4", isStepByStep: true, popular: false, title: "content_4", url: .arrange),
                .init(description: "content_5", isStepByStep: true, popular: false, title: "content_5", url: .arrange),
                .init(description: "content_6", isStepByStep: true, popular: false, title: "content_6", url: .arrange),
                .init(description: "content_7", isStepByStep: true, popular: false, title: "content_7", url: .arrange),
                .init(description: "content_8", isStepByStep: true, popular: false, title: "content_8", url: .arrange),
            ],
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService()
        )
        VerifySnapshotInNavigationController(
            viewController: sut,
            mode: .dark
        )
    }
}
