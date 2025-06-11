import SwiftUI
import GOVKit

struct LocalAuthorityConfirmationView: View {
    private let viewModel: LocalAuthorityConfirmationViewModel

    init(viewModel: LocalAuthorityConfirmationViewModel) {
        self.viewModel = viewModel
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
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismiss()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    var unitaryView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\(viewModel.unitarySuccessTitle) \(viewModel.localAuthorityItem.name)")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text(viewModel.unitarySuccessDescription)
                .foregroundColor(Color(UIColor.govUK.text.primary))
            Spacer()
        }.padding()
    }

    var twoTierView: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(viewModel.twoTierSucessTitle)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
                .padding([.bottom], 10)
            Text(viewModel.twoTierSuccessDescriptionOne)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .padding(.bottom, 4)
            Text(viewModel.twoTierSuccessDescriptionTwo)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .padding(.bottom, 6)
            VStack(alignment: .leading, spacing: 0) {
                if let parentAuthorityName = viewModel.localAuthorityItem.parent?.name {
                    Text("\u{2022} \(parentAuthorityName)")
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                }
                Text("\u{2022} \(viewModel.localAuthorityItem.name)")
                    .foregroundColor(Color(UIColor.govUK.text.primary))
            }.padding(.bottom, 8)
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
