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
            headerView
            listView
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
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        }.toolbar {
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
            viewModel.localAuthorities,
            id: \.localAuthority.slug
        ) { authority in
            RadioButtonView(
                title: authority.localAuthority.name,
                selected: isSelected(authority.localAuthority.slug)
            )
            .listRowSeparatorTint(Color(UIColor.govUK.strokes.listDivider))
            .listSectionSeparator(.hidden, edges: .bottom)
            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
            .onTapGesture {
                viewModel.selectedAuthority = authority
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
        return .constant(slug == viewModel.selectedAuthority?.localAuthority.slug)
    }
}
