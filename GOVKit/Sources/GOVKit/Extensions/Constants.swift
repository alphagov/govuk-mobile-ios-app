import Foundation

public struct Constants {
    public struct API {
        public static let govukUrlHost = "www.gov.uk"
        public static let govukUrlScheme = "https"
        private static let govukBaseComponents: URLComponents = {
            var components = URLComponents()
            components.host = govukUrlHost
            components.scheme = govukUrlScheme
            return components
        }()
        public static let govukBaseUrl: URL = govukBaseComponents.url!

        public static let appStoreAppUrl = URL(string: "https://beta.itunes.apple.com/v1/app/6572293285")!

        public static let helpAndFeedbackUrl: URL = {
            var components = govukBaseComponents
            components.path = "/contact/govuk-app"
            return components.url!
        }()

        public static let reportProblemUrl: URL = {
            var components = govukBaseComponents
            components.path = "/contact/govuk-app/report-problem"
            return components.url!
        }()

        public static let termsAndConditionsUrl: URL = {
            var components = govukBaseComponents
            components.path = "/government/publications/govuk-app-terms-and-conditions"
            return components.url!
        }()

        public static let accessibilityStatementUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /government/publications/accessibility-statement-for-the-govuk-app
            """
            return components.url!
        }()

        public static let privacyPolicyUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /government/publications/govuk-app-privacy-notice-how-we-use-your-data
            """
            return components.url!
        }()

        public static let defaultChatPrivacyPolicyUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /government/publications/govuk-chat-privacy-notice
            """
            return components.url!
        }()

        public static let defaultChatTermsUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /guidance/govuk-chat-terms-and-conditions
            """
            return components.url!
        }()

        public static let defaultChatAboutUrl: URL = {
            var components = govukBaseComponents
            components.path = """
            /guidance/about-govuk-chat
            """
            return components.url!
        }()

        public static let defaultChatFeedbackUrl: URL =
        URL(string: "https://surveys.publishing.service.gov.uk/s/SUIEH2/")!

        public static let defaultSearchUrl: URL = URL(string: "https://search.service.gov.uk")!

        public static var searchSuggestionsPath: String = "/api/search/autocomplete.json"

        public static var defaultSearchPath: String = "/v0_1/search.json"

        public static let authenticationCallbackUri: String = "govuk://govuk/login-auth-callback"

        public static var defaultLocalAuthorityURL: URL = URL(
            string: "https://www.gov.uk"
        )!

        public static var localAuthorityPath: String = "/api/local-authority"

        public static var manageAccountURL: URL = URL(
            string: "https://home.account.gov.uk/"
        )!
    }

    public struct SigningKey {
        public static let govUK = "integration_pubkey"
    }
}
