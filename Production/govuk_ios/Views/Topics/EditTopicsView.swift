import SwiftUI
import GOVKit

struct EditTopicsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    var viewModel: EditTopicsViewModel

    var body: some View {
        NavigationView {
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


    private var topicsList: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.sections) { topicRow in
                TopicListRowView(topicRow: topicRow)
            }
        }
    }
}

struct TopicListRowView: View {
    @ObservedObject var topicRow: TopicRow

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                let image = topicRow.isOn ? Image("topic_selected") : Image(uiImage: topicRow.icon)
                image
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
            Text(topicRow.title)
                .font(.govUK.bodySemibold)
            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.govUK.fills.surfaceCardSelected))
        .roundedBorder(borderColor: .clear)
        .onTapGesture {
            topicRow.isOn.toggle()
        }
    }
}

extension EditTopicsView: TrackableScreen {
    var trackingTitle: String? { "Edit your topics" }
    var trackingName: String { "Edit your topics" }
}
