import SwiftUI
import UIComponents

struct LocalAuthenticationSettingsView: View {
    @StateObject var viewModel: LocalAuthenticationSettingsViewModel

    init(viewModel: LocalAuthenticationSettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    Button {
                        viewModel.buttonAction()
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(viewModel.buttonTitle)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(
                                        Color(
                                            UIColor.govUK.text.primary
                                        )
                                    )
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(
                                        Color(
                                            UIColor.govUK.text.trailingIcon
                                        )
                                    )
                                    .font(Font.govUK.bodySemibold)
                            }
                        }
                    }
                    ForEach(viewModel.body.split(separator: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph)
                            .font(Font.govUK.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    Spacer()
                }
            }
            .accessibilityElement(children: .contain)
        }
    }
}
