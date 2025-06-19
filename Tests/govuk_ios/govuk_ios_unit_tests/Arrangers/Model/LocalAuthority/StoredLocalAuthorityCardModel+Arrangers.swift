import Foundation

@testable import govuk_ios

extension StoredLocalAuthorityCardModel {
    static var arrange: StoredLocalAuthorityCardModel {
        .arrange(
            name: "test",
            homepageUrl: "https://www.gov.uk/some-url",
            description: ""
        )
    }

    static func arrange(name: String,
                        homepageUrl: String,
                        description: String) -> StoredLocalAuthorityCardModel {
        StoredLocalAuthorityCardModel(
            name: name,
            homepageUrl: homepageUrl,
            description: description
        )
    }
}
