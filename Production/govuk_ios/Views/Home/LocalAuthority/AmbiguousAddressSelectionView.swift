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
            headerView
            listView
            Spacer()
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            SwiftUIButton(
                .primary,
                viewModel: viewModel.confirmButtonModel
            )
            .frame(minHeight: 44, idealHeight: 44)
            .disabled(viewModel.selectedAddress == nil)
        }
        .toolbar {
            cancelButton
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
        List(
            viewModel.addresses,
            id: \.address
        ) { address in
            RadioButtonView(
                title: address.address,
                selected: isSelected(address.address)
            )
            .listRowSeparatorTint(Color(UIColor.govUK.strokes.listDivider))
            .listSectionSeparator(.hidden, edges: .bottom)
            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
            .onTapGesture {
                viewModel.selectedAddress = address
            }
        }
        .listStyle(.plain)
        .padding(.trailing, 16)
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismissAction()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    private func isSelected(_ slug: String) -> Binding<Bool> {
        return .constant(slug == viewModel.selectedAddress?.address)
    }
}
