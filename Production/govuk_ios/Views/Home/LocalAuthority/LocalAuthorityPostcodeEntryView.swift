import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthorityPostcodeEntryView: View {
    @StateObject private var viewModel: LocalAuthorityViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.dismiss) var dismiss

    init(viewModel: LocalAuthorityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text(viewModel.postcodeEntryViewTitle)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(.title)
                        .fontWeight(.bold)
                        .accessibilityLabel(Text(viewModel.postcodeEntryViewTitle))
                        .accessibilityAddTraits(.isHeader)
                    Text(viewModel.postcodeEntryViewExampleText).foregroundColor(
                        Color(UIColor.govUK.text.secondary)
                    )
                    TextField(
                        "",
                        text: $viewModel.postCode
                    ).textFieldStyle(CustomTextFieldBorder())
                    Text(viewModel.postcodeEntryViewDescriptionTitle).font(
                        Font.govUK.bodySemibold
                    )
                    Text(viewModel.postcodeEntryViewDescriptionBody)
                    Spacer()
                }.padding()
                buttons
            }.navigationTitle(viewModel.navigationTitle)
                .toolbar {
                    doneButton
                }
                .navigationBarTitleDisplayMode(.inline)
        }.onAppear(perform: {
            viewModel.trackScreen(screen: self)
        })
    }

    private var doneButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                dismiss()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }

    @ViewBuilder
    var buttons: some View {
        let layout = verticalSizeClass == .compact ?
        AnyLayout(HStackLayout()) :
        AnyLayout(VStackLayout())
        VStack(alignment: .center, spacing: 16) {
            Divider()
                .background(Color(UIColor.govUK.strokes.listDivider))
                .ignoresSafeArea(edges: [.leading, .trailing])
                .padding([.top], 0)
            layout {
                SwiftUIButton(
                    .primary,
                    viewModel: viewModel.postcodeEntryViewPrimaryButtonViewModel
                )
                .accessibilityHint("")
                .frame(
                    minHeight: 44,
                    idealHeight: 44
                )
            }
            .padding([.leading, .trailing], verticalSizeClass == .regular ? 16 : 0)
        }
        .accessibilityElement(children: .contain)
    }
}

extension LocalAuthorityPostcodeEntryView: TrackableScreen {
    var trackingTitle: String? { "What is your postcode" }
    var trackingName: String { "What is your postcode" }
}
