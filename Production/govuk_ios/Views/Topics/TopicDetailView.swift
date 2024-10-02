import SwiftUI

struct TopicDetailView: View {
    var topic: Topic?

    var body: some View {
        Text(topic?.title ?? "No topic set")
    }
}

#Preview {
    TopicDetailView()
}
