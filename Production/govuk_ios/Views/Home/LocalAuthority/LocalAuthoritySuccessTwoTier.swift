import SwiftUI

struct LocalAuthoritySuccessTwoTier: View {
    let model: LocalAuthorityItem
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Services in your area are provided by 2 local councils")
                .foregroundColor(Color(UIColor.govUK.text.primary))
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Text("Different local councils are responsible for different services")
            Text("Your local councils are:")
            Text("\(model.parent?.name)")
            Text("\(model.name)")
            Text("You can now access your local councils’ websites from the bottom of the app home page")
            Spacer()
        }.padding()
    }
}
