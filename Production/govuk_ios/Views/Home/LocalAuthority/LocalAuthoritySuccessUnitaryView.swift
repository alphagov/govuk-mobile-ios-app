import SwiftUI

struct LocalAuthoritySuccessUnitaryView: View {
    let model: Authority
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Your local council is \(model.name) Council")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text("You can now")
                .foregroundColor(Color(UIColor.govUK.text.secondary))
            Spacer()
        }.padding()
    }
}
