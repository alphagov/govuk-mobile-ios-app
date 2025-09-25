import Foundation
import Testing
import UIKit
import Factory

@testable import govuk_ios

private class TestWebCoordinator: MockBaseCoordinator {
    var presentedCoordinator: BaseCoordinator?

    override func present(_ coordinator: BaseCoordinator, animated: Bool = true) {
        self.presentedCoordinator = coordinator
        super.present(coordinator, animated: animated)
    }
}

@Suite
@MainActor
struct WebDeeplinkRouteTests {
    
    @Test
    func pattern_returnsExpectedValue() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = WebDeeplinkRoute(coordinatorBuilder: mockCoordinatorBuilder)

        #expect(subject.pattern == "/web")
    }
    
    @Test
    func action_withValidURL_presentsWebCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let expectedCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedWebViewCoordinator = expectedCoordinator
        let subject = WebDeeplinkRoute(coordinatorBuilder: mockCoordinatorBuilder)
        let mockParentCoordinator = TestWebCoordinator()
        let testURL = "https://www.gov.uk/"
        let params = ["url": testURL]

        subject.action(parent: mockParentCoordinator, params: params)
        
        #expect(mockParentCoordinator.presentedCoordinator == expectedCoordinator)
    }
    
    @Test
    func action_withInvalidURL_doesNotPresentCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = WebDeeplinkRoute(coordinatorBuilder: mockCoordinatorBuilder)
        let mockParentCoordinator = TestWebCoordinator()
        let params = ["url": "invalid-url"]
        
        subject.action(parent: mockParentCoordinator, params: params)

        #expect(mockParentCoordinator.presentedCoordinator == nil)
    }
    
    @Test
    func action_withMissingURL_doesNotPresentCoordinator() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = WebDeeplinkRoute(coordinatorBuilder: mockCoordinatorBuilder)
        let mockParentCoordinator = TestWebCoordinator()
        let params: [String: String] = [:]
        
        subject.action(parent: mockParentCoordinator, params: params)

        #expect(mockParentCoordinator.presentedCoordinator == nil)
    }
} 
