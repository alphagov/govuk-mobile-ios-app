import Foundation
import SwiftUI

struct StoredLocalAuthorityCardView: View {
    let model: StoredLocalAuthorityCardModel
    var body: some View {
         //   VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(model.description)
                            .frame(maxHeight: .infinity)
                          //  .fixedSize(horizontal: false, vertical: true)
                            .font(.govUK.body)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.primary))
                        Text(model.name)
                            .frame(maxHeight: .infinity)
                          //  .fixedSize(horizontal: false, vertical: true)
                            .font(.govUK.title2Bold)
                            .foregroundColor(Color(uiColor: UIColor.govUK.text.link))
                           // .padding(.bottom, 2)

                    }
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                  //  .padding()
                }
       //     }
        .accessibilityLabel(model.name)
        .accessibilityAddTraits(.isLink)
        .accessibilityHint(String.common.localized("openWebLinkHint"))
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
    }
