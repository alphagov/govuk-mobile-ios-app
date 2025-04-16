import Foundation
import Testing
import Combine
@testable import govuk_ios

@Suite
struct LocalAuthorityViewModelTests {
    @Test
    func fetchlocalAuthority_addressList_returnsExpectedResults() async throws {
        var cancellables = Set<AnyCancellable>()
        let addresses:[LocalAuthorityAddress] = [
            LocalAuthorityAddress(
                address: "address1",
                slug: "slug1",
                name: "name1"
            ),
            LocalAuthorityAddress(
                address: "address2",
                slug: "slug2",
                name: "name2"
            )
        ]
        let expectedResult = LocalAuthoritiesList(addresses: addresses)
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)
        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$localAuthorityAdressList
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(result?.addresses.count == 2)
        #expect(result?.addresses.first?.name == "name1")
        #expect(result?.addresses.last?.name == "name2")
        #expect(result?.addresses.first?.slug == "slug1")
    }

    @Test
    func fetchLocaAuthority_tierOnelocalAuthority_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let authority = Authority(
            name: "name1",
            homepageUrl: "homepageUrl",
            tier: "tier1",
            slug: "slug1",
            parent: nil
        )
        let expectedResult = LocalAuthority(localAuthority: authority)
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)

        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$localAuthority
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(result?.localAuthority.homepageUrl == "homepageUrl")
        #expect(result?.localAuthority.name == "name1")
        #expect(result?.localAuthority.tier == "tier1")
        #expect(result?.localAuthority.slug == "slug1")
    }


    @Test
    func fetchLocaAuthority_tierTwolocalAuthority_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let parentAuthority = Authority(
            name: "parentAuthority",
            homepageUrl: "homepageUrl",
            tier: "parentTier",
            slug: "slug",
            parent: nil
        )

        let authority = Authority(
            name: "name2",
            homepageUrl: "homepageUrl",
            tier: "tier2",
            slug: "slug2",
            parent: parentAuthority
        )

        let expectedResult = LocalAuthority(localAuthority: authority)
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)

        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$localAuthority
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(result?.localAuthority.homepageUrl == "homepageUrl")
        #expect(result?.localAuthority.name == "name2")
        #expect(result?.localAuthority.tier == "tier2")
        #expect(result?.localAuthority.slug == "slug2")
        #expect(result?.localAuthority.parent?.name == "parentAuthority")
    }

    @Test
    func fetchLocaAuthority_localErrorMessage_returnsExpectedResult() async throws {
        var cancellables = Set<AnyCancellable>()
        let expectedResult = LocalErrorMessage(message: "error message")
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .success(expectedResult)

        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let result = await withCheckedContinuation { continuation in
            sut.$localAuthorityErrorMessage
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(result?.message == "error message")
    }

    @Test
    func fetchLocaAuthority_apiUnavailable_shouldShowErrorMessageIsTrue() async throws {
        var cancellables = Set<AnyCancellable>()
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .failure(.apiUnavailable)

        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let _: Publishers.Drop<ObservableObjectPublisher>.Output = await withCheckedContinuation { continuation in
            sut.objectWillChange
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(sut.shouldShowErrorMessage == true)
    }

    @Test
    func fetchLocaAuthority_decodingError_shouldShowErrorMessageIsTrue() async throws {
        var cancellables = Set<AnyCancellable>()
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .failure(.decodingError)

        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let _: Publishers.Drop<ObservableObjectPublisher>.Output = await withCheckedContinuation { continuation in
            sut.objectWillChange
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(sut.shouldShowErrorMessage == true)
    }

    @Test
    func fetchLocaAuthority_networkUnaivalable_shouldShowErrorMessageIsTrue() async throws {
        var cancellables = Set<AnyCancellable>()
        let mockService = MockLocalAuthorityService()
        mockService._stubbedFetchLocalResult = .failure(.networkUnavailable)

        let sut = LocalAuthorityViewModel(
            service: mockService,
            analyticsService: MockAnalyticsService(),
            action: { }
        )
        let _: Publishers.Drop<ObservableObjectPublisher>.Output = await withCheckedContinuation { continuation in
            sut.objectWillChange
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink { address in
                    continuation.resume(returning: address)
                }.store(in: &cancellables)
            sut.fetchLocalAuthority(postCode: "")
        }
        #expect(sut.shouldShowErrorMessage == true)
    }

    @Test
    func explainerViewPrimaryButtonViewModel_action_trackNavigationEvent() async throws {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthorityViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: mockAnalyticsService,
            action: { }
        )
        sut.explainerViewPrimaryButtonViewModel.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == "Continue")
    }

    @Test
    func postcodeEntryViewPrimaryButtonViewModel_action_trackNavigationEvent() async throws {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = LocalAuthorityViewModel(
            service: MockLocalAuthorityService(),
            analyticsService: mockAnalyticsService,
            action: { }
        )
        sut.postcodeEntryViewPrimaryButtonViewModel.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == "Confirm postcode")
    }
}
