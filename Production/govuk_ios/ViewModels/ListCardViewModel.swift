import Foundation

struct ListCardViewModel: Identifiable {
    let title: String
    let subtitle: String?
    let action: () -> Void

    var id: String {
        title
    }

    init(title: String,
         subtitle: String? = nil,
         action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
}
