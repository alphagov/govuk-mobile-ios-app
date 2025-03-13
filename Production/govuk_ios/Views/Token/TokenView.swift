import SwiftUI
import Factory
import UIComponents

struct TokenView: View {
    @StateObject private var viewModel: TokenViewModel

    init(viewModel: TokenViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 8) {
            TextField("Text to encrypt", text: $viewModel.token)
                .border(.tertiary)
                .padding()
            SwiftUIButton(
                .primary,
                viewModel: viewModel.encryptButtonViewModel
            )
            Text(viewModel.encryptedToken)
                .border(.primary)
            SwiftUIButton(
                .primary,
                viewModel: viewModel.decryptButtonViewModel
            )
            Text(viewModel.decryptedToken)
        }
        .padding()
    }
}

#Preview {
    let model = TokenViewModel(
        secureStoreService: Container.shared.secureStoreService.resolve()
    )
    TokenView(viewModel: model)
}
