import SwiftUI

struct RecentActivityErrorView: View {
    var body: some View {
        VStack {
            Text(String.recentActivity.localized(
                "recentActivityErrorViewTitle")
            )
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            Text(String.recentActivity.localized(
                "recentActivityErrorViewDescription")
            )
                .multilineTextAlignment(.center)
            Spacer()
        }.padding(.top)
    }
}
