import SwiftUI

struct RecentItemsErrorView: View {
    var body: some View {
        VStack {
            Text(NSLocalizedString(
                "errorViewTitle",
                bundle: .main,
                comment: "")).bold()
                .multilineTextAlignment(.center)
                .accessibilityLabel("").padding(.top)
            Text(NSLocalizedString(
                "errorViewDescription",
                bundle: .main,
                comment: ""))
            .multilineTextAlignment(.center)
            .accessibilityLabel("")
            Spacer()
        }.padding(.top)
    }
}
