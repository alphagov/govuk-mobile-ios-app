import SwiftUI

struct CarouselView: View {
    let carouselCardGroup: CarouselCardGroup

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(carouselCardGroup.title)
                    .font(.headline)
                Spacer()
                Button(
                    action: {},
                    label: {
                        Text("See all")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                )
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(carouselCardGroup.cards) { card in
                        CarouselCardViewRepresentable(card: card)
                            .frame(minHeight: 150)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
