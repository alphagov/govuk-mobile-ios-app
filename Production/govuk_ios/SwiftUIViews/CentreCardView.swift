import SwiftUI

struct CentreCardView: View {
    let model: CentreCard
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center, spacing: 8) {
                    Spacer()
                    Image(systemName: "plus.circle")
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.iconTertiary
                            )
                        )
                       .padding(.bottom, 2)
                        .font(.title)
                    if let title = model.primaryText {
                        Text(title)
                            .multilineTextAlignment(.center)
                            .font(Font.govUK.bodySemibold)
                            .foregroundColor(
                                Color(UIColor.govUK.text.primary))
                            .padding(.horizontal)
                    }
                    if let description = model.secondaryText {
                        Text(description)
                            .multilineTextAlignment(.center)
                            .font(Font.govUK.body)
                            .foregroundColor(
                                Color(UIColor.govUK.text.secondary))
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .background {
                Color(uiColor: UIColor.govUK.fills.surfaceList)
            }
            .roundedBorder(borderColor: .clear)
            .shadow(
                color: Color(
                    uiColor: UIColor.govUK.strokes.cardDefault
                ), radius: 0, x: 0, y: 3
            )
        }
        .padding(.horizontal)
    }
}
