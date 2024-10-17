import SwiftUI

struct TopicDetailView: View {
    @StateObject var viewModel: TopicDetailViewModel

    init(viewModel: TopicDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                Text(viewModel.topicDetail?.title
                     ?? viewModel.error?.localizedDescription
                     ?? "should be something")
                GroupedList(content: viewModel.sections)
            }
        }
        .navigationTitle(viewModel.topicDetail?.title ?? "")
        .navigationBarTitleDisplayMode(.large)
    }
}

// #Preview {
//    TopicDetailView()
// }
