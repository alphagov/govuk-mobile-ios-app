import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ZStack {
            Color(.splashScreenBlue)
            Image(decorative: "splash_logo")
            VStack {
                Spacer()
                Image(decorative: "splash_crown")
                    .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PrivacyView()
}
