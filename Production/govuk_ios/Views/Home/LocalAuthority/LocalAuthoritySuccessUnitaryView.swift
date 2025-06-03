import SwiftUI

struct LocalAuthoritySuccessUnitaryView: View {
    let councilName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your local council is \(councilName) Council")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text("You can now access your local council's website from the bottom of the app home page.")
                .foregroundColor(Color(UIColor.govUK.text.secondary))
            Spacer()
        }.padding()
    }
}
