import SwiftUI
import Foundation

struct RecentActivityErrorView: View {
    let errorTitle = String.recentActivity.localized(
        "recentActivityErrorViewTitle"
    )

    let errorDescription = String.recentActivity.localized(
        "recentActivityErrorViewDescription"
    )

    var body: some View {
        VStack(spacing: 8) {
            Text(errorTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            Text(errorDescription)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            Spacer()
        }
        .padding()
    }
}
