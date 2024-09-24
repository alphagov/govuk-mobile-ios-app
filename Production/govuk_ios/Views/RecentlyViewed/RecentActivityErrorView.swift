import SwiftUI

struct RecentActivityErrorView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text(String.recentActivity.localized(
                "recentActivityErrorViewTitle")
            )
            .bold()
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
            Text(String.recentActivity.localized(
                "recentActivityErrorViewDescription")
            )
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
            Spacer()
        }
        .padding()
    }
}
