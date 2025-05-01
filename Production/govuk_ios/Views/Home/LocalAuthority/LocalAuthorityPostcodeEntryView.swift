import SwiftUI
import GOVKit
import UIComponents

struct LocalAuthorityPostcodeEntryView: View {
    @StateObject private var viewModel: LocalAuthorityPostecodeEntryViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(viewModel: LocalAuthorityPostecodeEntryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text(viewModel.postcodeEntryViewTitle)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(.title)
                        .fontWeight(.bold)
                        .accessibilityAddTraits(.isHeader)
                    Text(viewModel.postcodeEntryViewExampleText)
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                    if let errorCase = viewModel.error {
                        withAnimation {
                            Text(errorCase.returnErrorMessage())
                                .foregroundColor(
                                    Color(uiColor: UIColor.govUK.text.buttonDestructive)
                                )
                                .font(Font.govUK.body)
                        }
                    }
                    TextField("", text: $viewModel.postCode)
                        .textFieldStyle(.customTextFieldBorder)
                    Text(viewModel.postcodeEntryViewDescriptionTitle)
                        .font(Font.govUK.bodySemibold)
                    Text(viewModel.postcodeEntryViewDescriptionBody)
                    Spacer()
                }.padding()
            }
            PrimaryButtonView(
                viewModel: viewModel.primaryButtonViewModel
            )
        }.toolbar {
            cancelButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.trackScreen(screen: self)
        }
    }

    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
            Button(viewModel.cancelButtonTitle) {
                viewModel.dismissAction()
            }
            .foregroundColor(Color(UIColor.govUK.text.link))
        }
    }
}

extension LocalAuthorityPostcodeEntryView: TrackableScreen {
    var trackingTitle: String? { "What is your postcode" }
    var trackingName: String { "What is your postcode" }
}
