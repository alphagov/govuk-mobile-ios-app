import Foundation
import XCTest

@testable import govuk_ios

class DeeplinkDataStoreTests: XCTestCase {

    func test_route_fileURL_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/test")
            ]
        )
        let url = URL(string: "file://services")!
        let result = subject.route(for: url)

        XCTAssertNil(result)
    }

    func test_route_inValidURL_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/wrong")
            ]
        )
        let url = URL(string: "https:app/services")!
        let result = subject.route(for: url)

        XCTAssertNil(result)
    }

    func test_route_validURL_noneMatchingComponents_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/wrong")
            ]
        )
        let url = URL(string: "https://app.gov.uk/services")!
        let result = subject.route(for: url)
        XCTAssertNil(result)
    }

    func test_route_noPathComponents_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/test")
            ]
        )
        let url = URL(string: "https://app.gov.uk")!
        let result = subject.route(for: url)

        XCTAssertNil(result)
    }

    func test_route_incorrectComponentNumber_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/one"),
                MockRoute(pattern: "/one/two")
            ]
        )
        let url = URL(string: "https://app.gov.uk/one/two/three")!
        let result = subject.route(for: url)

        XCTAssertNil(result)
    }

    func test_route_validURL_matchingComponents_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/one"),
                MockRoute(pattern: "/services"),
                MockRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services")!
        let result = subject.route(for: url)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
    }

    func test_route_validURL_matchingWildCardComponent_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/one"),
                MockRoute(pattern: "/services/*/test"),
                MockRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services/hello/test")!
        let result = subject.route(for: url)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
    }

    func test_route_validURL_withParams_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/one"),
                MockRoute(pattern: "/services/:service_id/test"),
                MockRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services/driving_service_id/test")!
        let result = subject.route(for: url)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.parameters["service_id"], "driving_service_id")
    }

    func test_route_validURL_withParams_withConflictingQueryParam_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockRoute(pattern: "/one"),
                MockRoute(pattern: "/services/:service_id/test"),
                MockRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services/driving_service_id/test?service_id=override_service")!
        let result = subject.route(for: url)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.parameters["service_id"], "override_service")
    }
}

struct MockRoute: DeeplinkRoute {

    let pattern: URLPattern

    func action(parent: BaseCoordinator, 
                params: [String : String]) { }
}
