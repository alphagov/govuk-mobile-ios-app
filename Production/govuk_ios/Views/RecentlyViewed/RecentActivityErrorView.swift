import SwiftUI

struct RecentActivityErrorView: View {
    var body: some View {
        VStack {
            Text("recentActivityErrorViewTitle".localized)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top)
            Text("recentActivityErrorViewDescription".localized)
                .multilineTextAlignment(.center)
            Spacer()
        }.padding(.top)
    }
}
