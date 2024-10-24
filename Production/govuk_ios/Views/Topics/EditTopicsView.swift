import SwiftUI

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel

    var body: some View {
        VStack {
            ScrollView {
                Text(String.topics.localized("editTopicsSubtitle"))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                GroupedList(content: viewModel.sections)
            }
        }
        .navigationTitle(String.topics.localized("editTopicsTitle"))
        .toolbar {
            HStack {
                Spacer()
                doneButton
            }
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var doneButton: some View {
        Button(String.topics.localized("doneButtonTitle")) {
            viewModel.dismissAction()
        }.foregroundColor(Color(UIColor.govUK.text.link))
    }
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
