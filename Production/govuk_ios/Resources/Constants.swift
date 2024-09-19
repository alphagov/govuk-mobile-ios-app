import Foundation

struct Constants {
    struct API {
        static let privacyPolicyUrl = "https://www.gov.uk/government/publications/govuk-app-privacy-notice-how-we-use-your-data"
#if DEBUG
        static let appConfigUrl = "https://app.integration.publishing.service.gov.uk"
#else
        static let appConfigUrl = "https://app.publishing.service.gov.uk"
#endif
        static let appConfigPath = "/appinfo/ios"
    }
}
