import SwiftUI

struct RecentActivityErrorView: View {
    var body: some View {
        VStack {
            Text(String.recentActivities.localized(
                "recentActivityErrorViewTitle")
            )
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            Text(String.recentActivities.localized(
                "recentActivityErrorViewDescription")
            )
                .multilineTextAlignment(.center)
            Spacer()
        }.padding(.top)
    }
}
