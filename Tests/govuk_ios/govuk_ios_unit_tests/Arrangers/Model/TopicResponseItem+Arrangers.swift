import Foundation

@testable import govuk_ios

extension TopicResponseItem {
    static var arrangeMultiple: [TopicResponseItem] {
        return [
            TopicResponseItem(ref: "driving-transport", title: "Driving & Transport"),
            TopicResponseItem(ref: "care", title: "Care"),
            TopicResponseItem(ref: "business", title: "Business")
        ]
    }
}
