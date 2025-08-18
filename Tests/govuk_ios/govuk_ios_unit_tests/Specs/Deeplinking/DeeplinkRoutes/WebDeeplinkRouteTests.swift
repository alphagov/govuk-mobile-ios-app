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
        let container = Container()
        let coordinatorBuilder = CoordinatorBuilder(container: container)
        let subject = WebDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
        
        #expect(subject.pattern == "/web")
    }
    
    @Test
    func action_withValidURL_presentsWebCoordinator() {
        let container = Container()
        let coordinatorBuilder = CoordinatorBuilder(container: container)
        let subject = WebDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
        let mockParentCoordinator = TestWebCoordinator()
        let testURL = "https://www.gov.uk/"
        let params = ["url": testURL]
        
        subject.action(parent: mockParentCoordinator, params: params)
        
        #expect(mockParentCoordinator.presentedCoordinator != nil)
        #expect(mockParentCoordinator.presentedCoordinator is WebViewCoordinator)
    }
    
    @Test
    func action_withInvalidURL_doesNotPresentCoordinator() {
        let container = Container()
        let coordinatorBuilder = CoordinatorBuilder(container: container)
        let subject = WebDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
        let mockParentCoordinator = TestWebCoordinator()
        let params = ["url": "invalid-url"]
        
        subject.action(parent: mockParentCoordinator, params: params)
        
        #expect(mockParentCoordinator.presentedCoordinator == nil)
    }
    
    @Test
    func action_withMissingURL_doesNotPresentCoordinator() {
        let container = Container()
        let coordinatorBuilder = CoordinatorBuilder(container: container)
        let subject = WebDeeplinkRoute(coordinatorBuilder: coordinatorBuilder)
        let mockParentCoordinator = TestWebCoordinator()
        let params: [String: String] = [:]
        
        subject.action(parent: mockParentCoordinator, params: params)
        
        #expect(mockParentCoordinator.presentedCoordinator == nil)
    }
} 
