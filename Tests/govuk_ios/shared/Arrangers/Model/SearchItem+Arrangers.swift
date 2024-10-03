import Foundation

@testable import govuk_ios

extension SearchItem {

    static var arrange: SearchItem {
        arrange()
    }

    static func arrange(title: String = UUID().uuidString,
                        description: String = UUID().uuidString,
                        link: String = "https://www.gov.uk/\(UUID().uuidString)") -> SearchItem {
        .init(
            title: title,
            description: description,
            link: URL(string: link)!
        )
    }

}
