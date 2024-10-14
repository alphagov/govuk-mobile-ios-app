import SwiftUI

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel

    var body: some View {
        VStack {
            Text("Topics you select will be shown on ")
                .multilineTextAlignment(.leading)
            ScrollView {
                GroupedList(content: viewModel.sections)
            }
        }
        .navigationTitle("Edit your topics")
        .toolbar {
            HStack {
                Spacer()
                Button("Done") {
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
