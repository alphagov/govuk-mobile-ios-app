import SwiftUI

struct HeaderView: View {
    private let title: String
    private let subheading: String

    init(title: String, subheading: String) {
        self.title = title
        self.subheading = subheading
    }

    var body: some View {
        VStack {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.largeTitleBold)
                .multilineTextAlignment(.leading)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(Text(title))
                .padding(.bottom, 16)
            Text(subheading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(Font.govUK.body)
                .multilineTextAlignment(.leading)
                .accessibilityLabel(Text(subheading))
        }
    }
}
