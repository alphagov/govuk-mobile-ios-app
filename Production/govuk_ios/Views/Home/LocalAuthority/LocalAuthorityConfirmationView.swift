import SwiftUI
import GOVKit

struct LocalAuthorityConfirmationView: View {
    @StateObject var viewModel: LocalAuthorityConfirmationViewModel

    init(viewModel: LocalAuthorityConfirmationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                if viewModel.localAuthorityItem.parent != nil {
                    twoTierView
                } else {
                    unitaryView
                }
            }
            PrimaryButtonView(
                viewModel: viewModel.primaryButtonViewModel
            )
        }.onAppear {
            viewModel.trackScreen(screen: self)
        }
        .toolbar {
            cancelButton
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button("cancel") {
                viewModel.completion()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    @ViewBuilder
    var unitaryView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\(viewModel.unitarySuccessTitle) \(viewModel.localAuthorityItem.name)")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text(viewModel.unitarySuccessDescription)
                .foregroundColor(Color(UIColor.govUK.text.primary))
            Spacer()
        }.padding()
    }

    @ViewBuilder
    var twoTierView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.twoTierSucessTitle)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text(viewModel.twoTierSuccessDescriptionOne)
                .foregroundColor(Color(UIColor.govUK.text.primary))
            Text(viewModel.twoTierSuccessDescriptionTwo)
                .foregroundColor(Color(UIColor.govUK.text.primary))
            VStack(alignment: .leading, spacing: 0) {
                if let parentAuthorityName = viewModel.localAuthorityItem.parent?.name {
                    Text("\u{2022} \(parentAuthorityName)")
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                }
                Text("\u{2022} \(viewModel.localAuthorityItem.name)")
                    .foregroundColor(Color(UIColor.govUK.text.primary))
            }
            Text(viewModel.twoTierSuccessDescriptionThree)
                .foregroundColor(Color(UIColor.govUK.text.primary))
            Spacer()
        }.padding()
    }
}


extension LocalAuthorityConfirmationView: TrackableScreen {
    var trackingTitle: String? { "Your local council" }
    var trackingName: String { "Your local council" }
}
