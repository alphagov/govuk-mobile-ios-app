import SwiftUI
import Foundation
import UIComponents

struct LocalAuthorityWidgetView: View {
    let tapAction: () -> Void
    var body: some View {
        VStack {
            Button(
                action: {
                    tapAction()
                },
                label: {
                    Text("Get started")
            })
            Image(systemName: "")
            Text("Add your topics")
            Text("Get quick access to your local council website")
        }
        .background {
            Color(uiColor: UIColor.govUK.fills.surfaceCardSelected)
                .ignoresSafeArea()
        }
    }
}
