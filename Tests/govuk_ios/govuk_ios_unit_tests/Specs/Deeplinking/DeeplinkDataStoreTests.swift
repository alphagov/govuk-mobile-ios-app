import Foundation
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct DeeplinkDataStoreTests {

    @Test
    func route_fileURL_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/test")
            ]
        )
        let url = URL(string: "file://services")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result == nil)
    }

    @Test
    func route_inValidURL_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/wrong")
            ]
        )
        let url = URL(string: "https:app/services")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result == nil)
    }

    @Test
    func route_urlScheme_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/services")
            ]
        )
        let url = URL(string: "govuk://services")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result == nil)
    }

    @Test
    func route_validURL_noneMatchingComponents_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/wrong")
            ]
        )
        let url = URL(string: "https://app.gov.uk/services")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result == nil)
    }

    @Test
    func route_noPathComponents_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/test")
            ]
        )
        let url = URL(string: "https://app.gov.uk")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result == nil)
    }

    @Test
    func route_incorrectComponentNumber_returnsNil() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/one"),
                MockDeeplinkRoute(pattern: "/one/two")
            ]
        )
        let url = URL(string: "https://app.gov.uk/one/two/three")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result == nil)
    }

    @Test
    func route_validURL_matchingComponents_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/one"),
                MockDeeplinkRoute(pattern: "/services"),
                MockDeeplinkRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result?.url == url)
        #expect(result?.parent == mockParent)
    }

    @Test
    func route_validURL_matchingWildCardComponent_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/one"),
                MockDeeplinkRoute(pattern: "/services/*/test"),
                MockDeeplinkRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services/hello/test")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result?.url == url)
        #expect(result?.parent == mockParent)
    }

    @Test
    func route_validURL_withParams_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/one"),
                MockDeeplinkRoute(pattern: "/services/:service_id/test"),
                MockDeeplinkRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services/driving_service_id/test")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result?.url == url)
        #expect(result?.parent == mockParent)
        #expect(result?.parameters["service_id"] == "driving_service_id")
    }

    @Test
    func route_validURL_withParams_withConflictingQueryParam_returnsRoute() {
        let subject = DeeplinkDataStore(
            routes: [
                MockDeeplinkRoute(pattern: "/one"),
                MockDeeplinkRoute(pattern: "/services/:service_id/test"),
                MockDeeplinkRoute(pattern: "/one/two"),
            ]
        )
        let url = URL(string: "https://app.gov.uk/services/driving_service_id/test?service_id=override_service")!
        let mockParent = MockBaseCoordinator()
        let result = subject.route(
            for: url,
            parent: mockParent
        )

        #expect(result?.url == url)
        #expect(result?.parent == mockParent)
        #expect(result?.parameters["service_id"] == "override_service")
    }
}
