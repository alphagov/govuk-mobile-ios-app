import Foundation

struct Constants {
    struct API {
        static let appBaseUrl = "https://app.integration.publishing.service.gov.uk"
        static let appStoreAppUrl = "https://beta.itunes.apple.com/v1/app/6572293285"
        static let govukUrlHost = "www.gov.uk"
        static let govukUrlScheme = "https"
        static let govukUrlString = "https://www.gov.uk"
        static let helpAndFeedbackUrl = "https://www.gov.uk/contact/govuk-app"

        static let termsAndConditionsUrl = "https://www.gov.uk/government/publications/govuk-app-terms-and-conditions"
        static let accessibilityStatementUrl = "https://www.gov.uk/government/publications/accessibility-statement-for-the-govuk-app"
        static let privacyPolicyUrl = "https://www.gov.uk/government/publications/govuk-app-privacy-notice-how-we-use-your-data"

        static let defaultSearchUrl: URL = URL(string: "https://search.service.gov.uk")!
        static var defaultSearchPath: String = "/v0_1/search.json"
    }

    struct SigningKey {
        static let govUK = "integration_pubkey"
    }
}
