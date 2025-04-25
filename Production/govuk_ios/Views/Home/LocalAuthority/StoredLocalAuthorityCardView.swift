import Foundation
import SwiftUI
struct StoredLocalAuthrorityCardView: View {
    let model: LocalAuthorityItem
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(Color(UIColor.govUK.text.link))
            }.padding(.bottom, 4)
            HStack {
                Text("Find services like rubbish and recycling collection")
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
}
