import SwiftUI

struct RecentActivityErrorView: View {
    var body: some View {
        VStack {
            Text(NSLocalizedString(
                "errorViewTitle",
                bundle: .main,
                comment: "")).bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            Text(NSLocalizedString(
                "errorViewDescription",
                bundle: .main,
                comment: ""))
            .multilineTextAlignment(.center)
            Spacer()
        }.padding(.top)
    }
}
