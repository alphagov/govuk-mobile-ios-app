import SwiftUI

struct TokenView: View {
    private let viewModel: TokenViewModel

    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
