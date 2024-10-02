import SwiftUI

struct TopicDetailView: View {
    var topic: Topic?

    var body: some View {
        Text(topic?.title ?? "No topic set")
    }
}

#Preview {
    let topic = Topic(ref: "topic", title: "Topic")
    TopicDetailView()
}
