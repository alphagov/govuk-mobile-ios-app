import SwiftUI
import UIComponents

struct BulletView: View {
    var bulletText: [String]
    var bulletSpacing: CGFloat
    var itemSpacing: CGFloat

    init(bulletText: [String],
         bulletSpacing: CGFloat = 20.0,
         itemSpacing: CGFloat = 8.0) {
        self.bulletText = bulletText
        self.bulletSpacing = bulletSpacing
        self.itemSpacing = itemSpacing
    }

    var body: some View {
        VStack(alignment: .leading,
               spacing: itemSpacing) {
            ForEach(bulletText, id: \.self) { text in
                HStack(alignment: .firstTextBaseline,
                       spacing: bulletSpacing) {
                    Text("•")
                        .font(Font.govUK.title1)
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .font(Font.govUK.body)
                }
            }
            .foregroundStyle(Color(UIColor.govUK.text.primary))
        }
               .padding(.horizontal, 16.0)
    }
}

#Preview {
    BulletView(
        bulletText: ["if you’re using Face ID or Touch ID to unlock the app, this will be off",
                     "you’ll stop sharing statistics about how you use the app"]
    )
}
