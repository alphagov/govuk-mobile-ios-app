import Foundation

final class EditTopicsViewModel: ObservableObject {
    @Published var topics: [Topic]
    var dismissAction: () -> Void

    init(topics: [Topic],
         dismissAction: @escaping () -> Void) {
        self.topics = topics
        self.dismissAction = dismissAction
    }
}
