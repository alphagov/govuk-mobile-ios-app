import SwiftUI

struct PrivacyView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        ZStack {
            Color(.splashScreenBlue)
            Image(decorative: "splash_logo")
            VStack {
                Spacer()
                Image(decorative: "splash_crown")
                    .padding(.bottom, verticalSizeClass == .compact ? 37 : 81)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PrivacyView()
}
