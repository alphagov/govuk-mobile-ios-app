import SwiftUI
import GOVKit
import UIComponents

struct AmbiguousAddressSelectionView: View {
    @StateObject private var viewModel: AmbiguousAddressSelectionViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AmbiguousAddressSelectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                HeaderView(
                    title: viewModel.title,
                    subheading: viewModel.subtitle
                )
                .padding()
                listView
                Spacer()
            }
            PrimaryButtonView(viewModel: viewModel.confirmButtonModel)
                .disabled(viewModel.selectedAddress == nil)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            cancelButton
        }
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var listView: some View {
        ForEach(
            viewModel.addresses,
            id: \.address
        ) { address in
            RadioButtonView(
                title: address.address,
                selected: isSelected(address.address),
                isLastRow: viewModel.addresses.last?.address == address.address
            )
            .onTapGesture {
                viewModel.selectedAddress = address
            }
        }
        .padding(.horizontal, 16)
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismissAction()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    private func isSelected(_ address: String) -> Binding<Bool> {
        return .constant(address == viewModel.selectedAddress?.address)
    }
}

extension AmbiguousAddressSelectionView: TrackableScreen {
    var trackingTitle: String? { "What is your address" }
    var trackingName: String { "What is your address" }
}
