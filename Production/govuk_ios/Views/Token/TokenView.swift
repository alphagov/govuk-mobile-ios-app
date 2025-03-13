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
                .textFieldStyle(.roundedBorder)
                .padding()
            SwiftUIButton(
                .primary,
                viewModel: viewModel.encryptButtonViewModel
            )
            Text(viewModel.encryptedToken ?? "Nothing encrypted")
                .padding()

            SwiftUIButton(
                .primary,
                viewModel: viewModel.decryptButtonViewModel
            )
            Text(viewModel.decryptedToken ?? "No decrypted data")
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(10)
            Spacer()
            SwiftUIButton(
                .secondary,
                viewModel: viewModel.deleteDataButtonViewModel
            )
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
