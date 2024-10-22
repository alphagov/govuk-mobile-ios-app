import Foundation

class TopicOnboardingCardModel: ObservableObject {
    let title: String
    let description: String
    let iconName: String
    let tapAction: (String, Bool) -> Void
    @Published var isSelected: Bool = false

    init(topic: Topic,
         tapAction: @escaping (String, Bool) -> Void) {
        self.title = topic.title
        self.description = "Starting a buisness, becoming self employed, running a buinsess"
        self.iconName = topic.iconName
        self.tapAction = tapAction
    }
}
