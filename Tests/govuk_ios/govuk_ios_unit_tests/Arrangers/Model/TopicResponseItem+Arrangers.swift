import Foundation

@testable import govuk_ios

extension TopicResponseItem {
    static var arrangeMultiple: [TopicResponseItem] {
        return [
            TopicResponseItem(
                ref: "driving-transport",
                title: "Driving & Transport",
                description: "Driving description"
            ),
            TopicResponseItem(
                ref: "care",
                title: "Care",
                description: "Care description"
            ),
            TopicResponseItem(
                ref: "business",
                title: "Business",
                description: "Business description"
            )
        ]
    }
}
