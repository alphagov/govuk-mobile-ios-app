import SwiftUI

struct TopicCard: View {
    let model: Topic
    let isLastInList: Bool
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                    Image(systemName: "cross")
                VStack {
                    HStack {
                        Text(model.title)
                        Spacer()
                        Text(Image(systemName: "chevron.right"))
                    }
                    if !isLastInList {
                        Divider()
                    }
                }
            }.padding([.horizontal, .top])
        }
    }
}
