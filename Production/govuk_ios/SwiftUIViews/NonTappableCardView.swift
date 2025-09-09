import SwiftUI

struct NonTappableCardView: View {
    var model: NonTappableCard
    var body: some View {
        HStack {
            Text(model.text)

        }
    }
}

#Preview {
    let model = NonTappableCard(text: "This card is to present text")
    NonTappableCardView(model: model)
}

struct NonTappableCard {
    var text: String
}
