import Foundation
import SwiftUI

struct SwiftUIWrappedButton: UIViewRepresentable {
    let config: GOVUKButton.ButtonConfiguration
    let viewModel: GOVUKButton.ButtonViewModel

    func makeUIView(context: Context) -> GOVUKButton {
        let button = GOVUKButton(config, viewModel: viewModel)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return button
    }

    func updateUIView(_ uiView: GOVUKButton, context: Context) {
        uiView.viewModel = viewModel
        uiView.buttonConfiguration = config
    }
}


public struct SwiftUIButton: View {
    public let config: GOVUKButton.ButtonConfiguration
    public let viewModel: GOVUKButton.ButtonViewModel

    public var body: some View {
        SwiftUIWrappedButton(config: config, viewModel: viewModel)
            .fixedSize(horizontal: false, vertical: true)
    }

    public init(_ config: GOVUKButton.ButtonConfiguration,
                viewModel: GOVUKButton.ButtonViewModel) {
        self.config = config
        self.viewModel = viewModel
    }
}
