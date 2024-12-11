import Foundation

struct Constants {
    struct API {
        static let govukUrlHost = "www.gov.uk"
        static let govukUrlScheme = "https"
        private static let govukBaseComponents: URLComponents = {
            var components = URLComponents()
            components.host = govukUrlHost
            components.scheme = govukUrlScheme
            return components
        }()
        static let govukBaseUrl: URL = govukBaseComponents.url!

        static let appStoreAppUrl = URL(string: "https://beta.itunes.apple.com/v1/app/6572293285")!

        static let helpAndFeedbackUrl: URL = {
            var components = govukBaseComponents
            components.path = "/contact/govuk-app"
            return components.url!
        }()

        static let termsAndConditionsUrl: URL = {
            var components = govukBaseComponents
            components.path = "/government/publications/govuk-app-terms-and-conditions"
            return components.url!
        }()

        static let accessibilityStatementUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /government/publications/accessibility-statement-for-the-govuk-app
            """
            return components.url!
        }()

        static let privacyPolicyUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /government/publications/govuk-app-privacy-notice-how-we-use-your-data
            """
            return components.url!
        }()

        static let defaultSearchUrl: URL = URL(string: "https://search.service.gov.uk")!

        static var defaultSearchPath: String = "/v0_1/search.json"
    }

    struct SigningKey {
        static let govUK = "integration_pubkey"
    }
}
