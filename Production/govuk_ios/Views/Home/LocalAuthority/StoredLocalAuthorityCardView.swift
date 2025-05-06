import Foundation
import SwiftUI

struct StoredLocalAuthorityCardView: View {
    let model: StoredLocalAuthorityCardModel
    var body: some View {
        ZStack {
            Color(uiColor: UIColor.govUK.fills.surfaceCardBlue)
            VStack {
                HStack {
                    Text(model.name)
                        .font(.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }
                .padding(.bottom, 4)
                HStack {
                    Text(model.description)
                        .font(.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(
                    Color(cgColor: UIColor.govUK.strokes.cardBlue.cgColor),
                    lineWidth: 0.5
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
