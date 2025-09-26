import Foundation

protocol DismissibleBanner {
    var id: String { get }
}

struct AlertBanner: DismissibleBanner, Decodable {
    let id: String
    let body: String
    let link: Link?
}

extension AlertBanner {
    struct Link: Decodable {
        let title: String
        let url: URL
    }
}

struct ChatBanner: DismissibleBanner, Decodable {
    let id: String
    let title: String
    let body: String
    let link: Link
}

extension ChatBanner {
    struct Link: Decodable {
        let title: String
        let url: URL
    }
}

struct UserFeedbackBanner: Decodable {
    let body: String
    let link: Link
}

extension UserFeedbackBanner {
    struct Link: Decodable {
        let title: String
        let url: URL
    }
}
