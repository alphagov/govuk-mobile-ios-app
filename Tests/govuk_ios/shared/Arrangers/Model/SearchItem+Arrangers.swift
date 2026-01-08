import Foundation

@testable import govuk_ios

extension SearchItem {

    static var arrange: SearchItem {
        arrange()
    }

    static func arrange(title: String = UUID().uuidString,
                        description: String = UUID().uuidString,
                        contentId: String = UUID().uuidString,
                        link: String = "https://www.gov.uk/\(UUID().uuidString)") -> SearchItem {
        .init(
            title: title,
            description: description,
            contentId: contentId,
            link: URL(string: link)!
        )
    }

}
