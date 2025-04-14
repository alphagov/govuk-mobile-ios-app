import Foundation

class Authority: Codable,
                 LocalAuthorityType {
    let name: String
    let homepageUrl: String
    let tier: String
    let slug: String
    var parent: Authority?

    init(name: String,
         homepageUrl: String,
         tier: String,
         slug: String,
         parent: Authority? = nil) {
        self.name = name
        self.homepageUrl = homepageUrl
        self.tier = tier
        self.slug = slug
        self.parent = parent
    }

    enum CodingKeys: String,
                     CodingKey {
        case homepageUrl = "homepage_url"
        case name
        case tier
        case slug
        case parent
    }
}
