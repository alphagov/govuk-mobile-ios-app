import SwiftUI
import GOVKit

struct EditTopicsView: View {
    @StateObject var viewModel: EditTopicsViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

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
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                doneButton
            }
            .toolbarBackground(.background, for: .navigationBar)
            .onAppear {
                viewModel.trackScreen(screen: self)
            }
            .onDisappear {
                viewModel.undoChanges()
            }
        }
        .id(colorScheme)
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
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
