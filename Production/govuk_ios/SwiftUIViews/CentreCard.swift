import SwiftUI

struct CentreCard: View {
    let model: CentreCardModel
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "plus.circle")
                        .foregroundColor(
                            Color(
                                UIColor.govUK.text.iconTertiary
                            )
                        )
                        .padding(.bottom, 6)
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

struct CentreCardModel {
    init(primaryText: String? = nil, secondaryText: String? = nil) {
        self.primaryText = primaryText
        self.secondaryText = secondaryText
    }
    let primaryText: String?
    let secondaryText: String?
}
