import SwiftUI

struct HomepageWidget: View,
                       Identifiable {
    let content: any View
    let id = UUID().uuidString

    init(content: any View) {
        self.content = content
    }

    var body: some View {
        AnyView(content)
    }
}
