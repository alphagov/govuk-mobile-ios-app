import Foundation
import Testing
@testable import govuk_ios

@Suite
struct AppEvent_ConvenienceTests {

    @Test
    func appLoaded_returnsExpectedResult() {
        let result = AppEvent.appLoaded

        #expect(result.name == "app_loaded")
        #expect(result.params?.count == 1)
        #expect(result.params?["device_model"] as? String == DeviceModel().description)
    }

    @Test
    func navigation_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedType = UUID().uuidString
        let expectedExternal = Int.random(in: 1...100) % 2 == 0
        let result = AppEvent.navigation(
            text: expectedText,
            type: expectedType,
            external: expectedExternal
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == expectedType)
        #expect(result.params?["external"] as? Bool == expectedExternal)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func tabNavigation_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.tabNavigation(
            text: expectedText
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Tab")
        #expect(result.params?["external"] as? Bool == false)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func buttonNavigation_external_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.buttonNavigation(
            text: expectedText,
            external: true
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func buttonNavigation_internal_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.buttonNavigation(
            text: expectedText,
            external: false
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["external"] as? Bool == false)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func searchTerm_returnsExpectedResult() {
        let expectedTerm = UUID().uuidString
        let result = AppEvent.searchTerm(term: expectedTerm)

        #expect(result.name == "Search")
        #expect(result.params?.count == 1)
        #expect(result.params?["text"] as? String == expectedTerm)
    }

    @Test
    func searchItemNavigation_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedURL = URL(string: "https://www.gov.uk/random")!
        let result = AppEvent.searchResultNavigation(
            title: expectedTitle,
            url: expectedURL,
            external: true
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 5)
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["url"] as? String == "https://www.gov.uk/random")
        #expect(result.params?["type"] as? String == "SearchResult")
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
    }
    
    @Test(arguments:[true, false])
    func toggleTopic_returnsExpectedResult(isFavorite: Bool) {
        let expectedTitle = UUID().uuidString
        let expectedValue = isFavorite ? "On" : "Off"
        let result = AppEvent.toggleTopic(
            title: expectedTitle,
            isFavorite: isFavorite
        )
        #expect(result.name == "Function")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "toggle")
        #expect(result.params?["section"] as? String == "Topics")
        #expect(result.params?["action"] as? String == expectedValue)
    }

    @Test
    func function_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedType = UUID().uuidString
        let expectedSection = UUID().uuidString
        let expectedAction = UUID().uuidString
        let result = AppEvent.function(
            text: expectedText,
            type: expectedType,
            section: expectedSection,
            action: expectedAction
        )

        #expect(result.name == "Function")
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == expectedType)
        #expect(result.params?["section"] as? String == expectedSection)
        #expect(result.params?["action"] as? String == expectedAction)
    }

    @Test
    func buttonFunction_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedSection = UUID().uuidString
        let expectedAction = UUID().uuidString
        let result = AppEvent.buttonFunction(
            text: expectedText,
            section: expectedSection,
            action: expectedAction
        )

        #expect(result.name == "Function")
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == expectedSection)
        #expect(result.params?["action"] as? String == expectedAction)
    }
}
