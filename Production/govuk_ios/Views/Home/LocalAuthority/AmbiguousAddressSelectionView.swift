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
                headerView
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

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.title)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text(viewModel.subtitle)
                .foregroundColor(Color(UIColor.govUK.text.secondary))
        }
        .padding()
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
