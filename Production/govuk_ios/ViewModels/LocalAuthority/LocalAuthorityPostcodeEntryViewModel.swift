import Foundation
import UIComponents
import GOVKit
import SwiftUI

class LocalAuthorityPostcodeEntryViewModel: ObservableObject {
    private let service: LocalAuthorityServiceInterface
    @Published var postCode: String = ""
    @Published var error: PostcodeError?
    @Published var textFieldColour: UIColor = UIColor.govUK.strokes.listDivider
    private let analyticsService: AnalyticsServiceInterface
    let dismissAction: () -> Void
    private let localAuthoritySelected: (Authority) -> Void
    let resolveAmbiguityAction: (AmbiguousAuthorities, String) -> Void
    let cancelButtonTitle: String = String.common.localized(
        "cancel"
    )
    let postcodeEntryViewDescription: String = String.localAuthority.localized(
        "localAuthrorityExplainerViewDescription"
    )
    let postcodeEntryViewTitle: String =  String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewTitle"
    )
    let postcodeEntryViewExampleText: String = String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewExampleText"
    )
    let entryFieldAccessibilityLabel: String = String.localAuthority.localized(
        "postcodeEntryAccessibilityLabel"
    )
    let postcodeEntryViewDescriptionTitle: String = String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewDescriptionTitle"
    )
    let postcodeEntryViewDescriptionBody: String = String.localAuthority.localized(
        "localAuthorityPostcodeEntryViewDescriptionBody"
    )
    private let postcodeEntryViewPrimaryButtonTitle: String = String.localAuthority.localized(
        "localAuthoritypostcodeEntryPrimaryButtonTitle"
    )

    private var authorityAddresses: [LocalAuthorityAddress] = []
    private var authorities: [Authority] = []

    init(service: LocalAuthorityServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         resolveAmbiguityAction: @escaping (AmbiguousAuthorities, String) -> Void,
         localAuthoritySelected: @escaping (Authority) -> Void,
         dismissAction: @escaping () -> Void) {
        self.service = service
        self.localAuthoritySelected = localAuthoritySelected
        self.analyticsService = analyticsService
        self.resolveAmbiguityAction = resolveAmbiguityAction
        self.dismissAction = dismissAction
    }

    enum PostcodeError: String {
        case postCodeNotFound = "localAuthorityPostcodeNotFound"
        case textFieldEmpty = "localAuthorityEmptyTextField"
        case invalidPostcode = "localAuthorityInvalidPostcode"
        case pageNotWorking = "localAuthorityPageNotWorking"
        case networkUnavailable = "localAuthorityNetworkUnavailable"

        var errorMessage: String {
            String.localAuthority.localized(
                rawValue
            )
        }
    }

    private func fetchAuthoritiesWithAddresses(_ addresses: [LocalAuthorityAddress]) {
        let uniqueSlugs = filterSlugs(addresses: addresses)

        service.fetchLocalAuthorities(slugs: uniqueSlugs) { [weak self] result in
            switch result {
            case .success(let localAuthorities):
                guard let self = self else { return }
                let ambiguousAuthorities = AmbiguousAuthorities(
                    authorities: localAuthorities,
                    addresses: addresses
                )
                self.resolveAmbiguityAction(ambiguousAuthorities, self.postCode)
            case .failure(let error):
                self?.populateErrorMessage(error)
            }
        }
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }

    private func trackNavigationEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: true
        )
        analyticsService.track(event: event)
    }

    private func filterSlugs(addresses: [LocalAuthorityAddress]) -> [String] {
        let uniqueSlugs = Set(addresses.map { $0.slug })
        return Array(uniqueSlugs)
    }

    var primaryButtonViewModel: GOVUKButton.ButtonViewModel {
        .init(
            localisedTitle: postcodeEntryViewPrimaryButtonTitle,
            action: { [weak self] in
                guard let self = self else { return }
                if postCode.isEmpty {
                    self.error = .textFieldEmpty
                    self.setErrorTextFieldColour()
                    return
                }
                let sanitisedPostcode = self.preprocessTextInput(
                    postcode: postCode
                )
                let buttonTitle = self.postcodeEntryViewPrimaryButtonTitle
                self.trackNavigationEvent(buttonTitle)
                self.fetchLocalAuthority(postCode: sanitisedPostcode)
            }
        )
    }

    private func preprocessTextInput(postcode: String) -> String {
        let upperCasedText = postcode.uppercased()
        let textWithoutUnderScores = upperCasedText.replacingOccurrences(
            of: "_",
            with: ""
        )
        let removedWhiteSpace = textWithoutUnderScores.filter {!$0.isWhitespace}
        return removedWhiteSpace
    }

    private func setErrorTextFieldColour() {
        textFieldColour = UIColor.govUK.strokes.error
    }

    func fetchLocalAuthority(postCode: String) {
        service.fetchLocalAuthority(postcode: postCode) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleFetchLocalAuthorityResponse(response)
            case .failure(let error):
                self?.populateErrorMessage(error)
            }
        }
    }

    private func handleFetchLocalAuthorityResponse(_ response: LocalAuthorityResponse) {
        switch response.type {
        case .authority(let authority):
            localAuthoritySelected(authority)
        case .addresses(let addressess):
            fetchAuthoritiesWithAddresses(addressess)
        case .unknown:
            populateErrorMessage(.apiUnavailable)
        }
    }

    private func populateErrorMessage(_ error: LocalAuthorityError) {
        switch error {
        case .invalidPostcode:
            self.error = .invalidPostcode
        case .unknownPostcode:
            self.error = .postCodeNotFound
        case .apiUnavailable:
            self.error = .pageNotWorking
        case .networkUnavailable:
            self.error = .networkUnavailable
        default:
            self.error = .pageNotWorking
        }
        setErrorTextFieldColour()
    }
}
