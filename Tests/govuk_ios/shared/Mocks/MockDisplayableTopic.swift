import Foundation

@testable import govuk_ios

struct MockDisplayableTopic: DisplayableTopic {
    let ref: String
    let title: String
    let topicDescription: String?
}
