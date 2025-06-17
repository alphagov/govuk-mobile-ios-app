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
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        viewModel.buttonAction()
                    } label: {
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
                        .padding(.horizontal, 16)
                        .padding(.vertical, 11)
                        .background(Color(UIColor.govUK.fills.surfaceList))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(UIColor.govUK.strokes.cardBlue), lineWidth: 0.5)
                        )
                    }
                    ForEach(viewModel.body.split(separator: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph).font(Font.govUK.body)
                    }
                }
                .padding(16)
            }
            .accessibilityElement(children: .contain)
        }
    }
}
