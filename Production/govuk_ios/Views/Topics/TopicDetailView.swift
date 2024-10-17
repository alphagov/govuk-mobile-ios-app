import SwiftUI

struct TopicDetailView: View {
    @StateObject var viewModel: TopicDetailViewModel

    init(viewModel: TopicDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text(viewModel.topic.title)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    Spacer()
                }
                GroupedList(content: viewModel.sections)
            }
        }
        .navigationTitle(viewModel.topic.title)
    }
}
