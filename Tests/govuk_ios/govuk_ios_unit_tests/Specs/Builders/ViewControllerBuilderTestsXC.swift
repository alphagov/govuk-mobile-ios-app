import CoreData
import Foundation
import SwiftUI
import XCTest

@testable import govuk_ios

@MainActor
final class ViewControllerBuilderTestsXC: XCTestCase {

    var subject: ViewControllerBuilder!
    
    override func setUp() {
        super.setUp()
        subject = ViewControllerBuilder()
    }

    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func test_driving_returnsExpectedResult() {
        let result = subject.driving(
            showPermitAction: {},
            presentPermitAction: {}
        )

        XCTAssertTrue(result is TestViewController)
        XCTAssertEqual(result.title, "Driving")
    }
    
    func test_permit_returnsExpectedResult() {
        let result = subject.permit(
            permitId: "123",
            finishAction: {}
        )

        XCTAssertTrue(result is TestViewController)
        XCTAssertEqual(result.title, "Permit - 123")
    }
    
    func test_home_returnsExpectedResult() {
        let result = subject.home(
            searchButtonPrimaryAction: { () -> Void in },
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            recentActivityAction: {},
            topicAction: { _ in }
        )

        XCTAssertTrue(result is HomeViewController)
    }
    
    func test_settings_returnsExpectedResult() {
        let result = subject.settings(
            analyticsService: MockAnalyticsService()
        )

        XCTAssertTrue(result is SettingsViewController)
    }
    
    func test_search_returnsExpectedResult() {
        let result = subject.search(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            dismissAction: { }
        )

        XCTAssertTrue(result is SearchViewController)
    }
    
    func test_recentActivity_returnsExpectedResult() {
        let result = subject.recentActivity(
            analyticsService: MockAnalyticsService()
        )

        let rootView = (result as? HostingViewController<ModifiedContent<RecentActivityContainerView, _EnvironmentKeyWritingModifier<NSManagedObjectContext>>>)?.rootView
        let containerView = rootView?.content as? RecentActivityContainerView
        XCTAssertEqual(containerView?.trackingClass, "RecentActivityContainerView")
        XCTAssertEqual(containerView?.trackingName, "Pages you've visited")
        XCTAssertEqual(containerView?.trackingTitle, "Pages you've visited")
    }
    
    func test_topicDetail_returnsExpectedResult() async throws {
        let result = subject.topicDetail(
            topic: Topic(ref: "ref", title: "Title"),
            analyticsService: MockAnalyticsService()
        )
        
        let rootView = (result as? HostingViewController<TopicDetailView>)?.rootView
        XCTAssertNotNil(rootView)
    }
}
