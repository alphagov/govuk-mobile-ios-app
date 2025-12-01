import SwiftUI
import GOVKit

struct EditTopicsView: View {
    @Environment(\.dismiss) var dismiss

    var viewModel: EditTopicsViewModel

    var body: some View {
        VStack {
            ScrollView {
                Text(String.topics.localized("editTopicsSubtitle"))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                topicsList
                    .padding([.top, .horizontal], 16)
            }
        }
        .navigationTitle(String.topics.localized("editTopicsTitle"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            doneButton
        }
        .toolbarBackground(Color(.govUK.fills.surfaceModal), for: .navigationBar)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
        .background(Color(.govUK.fills.surfaceModal))
    }

    private var doneButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(String.topics.localized("doneButtonTitle")) {
                dismiss()
            }
            .foregroundColor(Color(UIColor.govUK.text.buttonSecondary))
            .fontWeight(.medium)
        }
    }


    private var topicsList: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.topicSelectionCards) { topicSelectionCard in
                TopicSelectionCardView(viewModel: topicSelectionCard)
            }
        }
    }
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
