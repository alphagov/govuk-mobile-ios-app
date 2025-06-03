import SwiftUI
import GOVKit

struct LocalAuthoritySuccessView: View {
    @StateObject var viewModel: LocalAuthoritySuccessViewModel

    init(viewModel: LocalAuthoritySuccessViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                if viewModel.localAuthorityItem.parent != nil {
                    LocalAuthoritySuccessTwoTier(model: viewModel.localAuthorityItem)
                }
                LocalAuthoritySuccessUnitaryView(model: viewModel.localAuthorityItem)
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
}


extension LocalAuthoritySuccessView: TrackableScreen {
    var trackingTitle: String? { "Ask Andrew" }
    var trackingName: String { "Ask Andrew" }
}
