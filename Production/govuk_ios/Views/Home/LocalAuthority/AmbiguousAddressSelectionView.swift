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
        ZStack {
            Color(uiColor: .govUK.fills.surfaceModal)
            VStack {
                HStack {
                    Spacer()
                    Button(
                        action: {
                            viewModel.dismissAction()
                        }, label: {
                            Text(String.common.localized("cancel"))
                                .foregroundColor(
                                    Color(UIColor.govUK.text.linkSecondary)
                                )
                                .font(Font.govUK.subheadlineSemibold)
                        }
                    )
                }
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
                    .padding(.bottom, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.trackScreen(screen: self)
            }
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

    private func isSelected(_ address: String) -> Binding<Bool> {
        return .constant(address == viewModel.selectedAddress?.address)
    }
}

extension AmbiguousAddressSelectionView: TrackableScreen {
    var trackingTitle: String? { "What is your address" }
    var trackingName: String { "What is your address" }
}
