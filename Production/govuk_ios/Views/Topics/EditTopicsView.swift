import SwiftUI
import GOVKit

struct EditTopicsView: View {
    @Environment(\.dismiss) var dismiss

    var viewModel: EditTopicsViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                modifiedScrollView(geometry: geometry)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationTitle(String.topics.localized("editTopicsTitle"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                doneButton
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.trackScreen(screen: self)
            }
            .background(Color(.govUK.fills.surfaceModal))
        }
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

    @ViewBuilder
    func modifiedScrollView(geometry: GeometryProxy) -> some View {
        if #available(iOS 17.0, *) {
            scrollView
                .contentMargins(.bottom, geometry.safeAreaInsets.bottom, for: .scrollContent)
        } else {
            scrollView
        }
    }

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            Text(String.topics.localized("editTopicsSubtitle"))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.top, 10)
            topicsList
                .padding([.top, .horizontal], 16)
        }
        .clipped()
    }
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
