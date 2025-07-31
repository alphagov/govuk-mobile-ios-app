import SwiftUI
import GOVKit

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text(String.topics.localized("editTopicsSubtitle"))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 12)
                        .padding(.top, 10)
                    GroupedList(content: viewModel.sections)
                        .padding(.top, 16)
                }
            }
            .navigationTitle(String.topics.localized("editTopicsTitle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                doneButton
            }
            .onAppear {
                viewModel.trackScreen(screen: self)
            }
            .onDisappear {
                viewModel.undoChanges()
            }
        }
    }
    private var doneButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(String.topics.localized("doneButtonTitle")) {
                dismiss()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
