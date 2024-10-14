import SwiftUI

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel

    var body: some View {
        VStack {
            Text(String.topics.localized("editTopicsSubtitle"))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.top, 10)
            ScrollView {
                GroupedList(content: viewModel.sections)
            }
        }
        .navigationTitle(String.topics.localized("editTopicsTitle"))
        .toolbar {
            HStack {
                Spacer()
                Button(String.topics.localized("doneButtonTitle")) {
                    viewModel.updateFavoriteTopics()
                }
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
