import Foundation
import UIComponents
import GOVKit
import SwiftUI

class LocalAuthorityPostecodeEntryViewModel: ObservableObject {
    private let service: LocalAuthorityServiceInterface
    @Published var localAuthorityAddressList: LocalAuthoritiesList?
    @Published var postCode: String = ""
    @Published var error: PostcodeError?
    @Published var textFieldColour: UIColor = UIColor.govUK.strokes.listDivider
    private let analyticsService: AnalyticsServiceInterface
    let dismissAction: () -> Void
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
        "localAthorityPostcodeEntryViewExampleText"
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

    init(service: LocalAuthorityServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.service = service
        self.analyticsService = analyticsService
        self.dismissAction = dismissAction
    }

    enum PostcodeError: String {
        case postCodeNotFound = "localAuthorityPostcodeNotFound"
        case textFieldEmpty = "localAuthorityEmptyTextField"
        case invalidPostcode = "localAuthorityInvalidPostcode"

        var errorMessage: String {
            String.localAuthority.localized(
                rawValue
            )
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
        service.fetchLocalAuthority(postcode: postCode) { [weak self] results
            in
            switch results {
            case .success(_ as LocalAuthority):
                self?.dismissAction()
            case .success(let response as LocalAuthoritiesList):
                self?.localAuthorityAddressList = response
            case .success(let response as LocalErrorMessage):
                self?.populateErrorMessage(error: response)
            default:
                break
            }
        }
    }

    private func populateErrorMessage(error: LocalErrorMessage) {
        switch error.message {
        case "Invalid postcode":
            self.error  = .invalidPostcode
        case "Postcode not found":
            self.error = .postCodeNotFound
        default:
            break
        }
        setErrorTextFieldColour()
    }
}
