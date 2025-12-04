import SwiftUI
import UIComponents

struct BulletView: View {
    private let bulletText: [String]
    private let bulletSpacing: CGFloat
    private let itemSpacing: CGFloat

    init(bulletText: [String],
         bulletSpacing: CGFloat = 16.0,
         itemSpacing: CGFloat = 8.0) {
        self.bulletText = bulletText
        self.bulletSpacing = bulletSpacing
        self.itemSpacing = itemSpacing
    }

    var body: some View {
        VStack(spacing: itemSpacing
        ) {
            ForEach(bulletText, id: \.self) { text in
                HStack(alignment: .top, spacing: bulletSpacing) {
                    Text("•")
                        .font(Font.govUK.body)
                        .fontWeight(Font.Weight.heavy)
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .font(Font.govUK.body)
                    Spacer()
                }
            }
            .foregroundStyle(Color(UIColor.govUK.text.primary))
            .accessibilityElement(children: .combine)
        }
        .padding(.trailing, 16)
        .padding(.leading, 10)
    }
}

#Preview {
    BulletView(
        bulletText: ["if you’re using Face ID or Touch ID to unlock the app, this will be off",
                     "you’ll stop sharing statistics about how you use the app"]
    )
}
