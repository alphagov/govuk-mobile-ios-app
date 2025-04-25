import Foundation

class StoredLocalAuthorityWidgetCardModel {
    var name: String
    var homepageUrl: String
    var description: String

    init(name: String,
         homepageUrl: String,
         description: String) {
        self.name = name
        self.homepageUrl = homepageUrl
        self.description = description
    }
}
