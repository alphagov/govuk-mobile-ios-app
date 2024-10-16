import Foundation
import Testing

@testable import  govuk_ios

@Suite
struct AppEvent_RecentActivityTests {
    @Test
    func recentActivityNavigation_returnsExpectedResult() {
        let coreData = CoreDataRepository.arrange
        let expectedActivity = ActivityItem.arrange(context: coreData.viewContext)
        let result = AppEvent.recentActivityNavigation(
            activity: expectedActivity
        )

        #expect(result.name == "Navigation")
        #expect(result.params?["type"] as? String == "RecentActivity")
        #expect(result.params?["text"] as? String == expectedActivity.title)
        #expect(result.params?["url"] as? String == expectedActivity.url)
    }

    @Test
    func recentActivityButtonFunction_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedAction = UUID().uuidString
        let result = AppEvent.recentActivityButtonFunction(
            title: expectedTitle,
            action: expectedAction
        )

        #expect(result.name == "Function")
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["action"] as? String == expectedAction)
        #expect(result.params?["section"] as? String == "Pages you've visited")
    }
}
