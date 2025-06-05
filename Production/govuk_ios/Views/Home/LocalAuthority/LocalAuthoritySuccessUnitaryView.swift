import SwiftUI

struct LocalAuthoritySuccessUnitaryView: View {
    private let model: Authority
    private let title: String = String.localAuthority.localized(
        "localAuthoritySuccessUnitaryTitle"
    )
    private let description: String = String.localAuthority.localized(
        "localAuthoritySuccessUnitaryDescription"
    )
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\(title)\(model.name)")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text(description)
                .foregroundColor(Color(UIColor.govUK.text.secondary))
            Spacer()
        }
    }
}
