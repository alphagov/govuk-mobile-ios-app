import SwiftUI
import GOVKit
import UIComponents

struct AmbiguousAuthoritySelectionView: View {
    @StateObject private var viewModel: AmbiguousAuthoritySelectionViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: AmbiguousAuthoritySelectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(viewModel.title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                Text(viewModel.subtitle)
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
            }
            List(viewModel.localAuthorities,
                 selection: $viewModel.selectedAuthority) {
                RadioButtonView(
                    title: $0.localAuthority.name,
                    selected: isSelected($0.localAuthority.slug)
                )
                .listRowSeparator(.hidden)
                .tag($0)
            }
            .listStyle(.plain)
            Spacer()
            Divider()
                .overlay(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea()
            let buttonLayout = verticalSizeClass == .compact ?
            AnyLayout(HStackLayout()) :
            AnyLayout(VStackLayout())
            buttonLayout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.confirmButtonModel
                )
                .frame(minHeight: 44, idealHeight: 44)
                .disabled(viewModel.selectedAuthority == nil)
                SwiftUIButton(
                    .secondary,
                    viewModel: viewModel.selectAddressButtonModel
                )
                .frame(minHeight: 44, idealHeight: 44)
            }
            .ignoresSafeArea()
            .padding(16)
        }
    }

    private func isSelected(_ slug: String) -> Binding<Bool> {
        return .constant(slug == viewModel.selectedAuthority?.localAuthority.slug)
    }
}
