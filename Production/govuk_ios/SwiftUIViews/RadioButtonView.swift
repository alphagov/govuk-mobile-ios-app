import SwiftUI
import GOVKit
import UIComponents

struct RadioButtonView: View {
    @Binding var selected: Bool
    var title: String

    init(title: String,
         selected: Binding<Bool>) {
        self.title = title
        self._selected = selected
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(selected ? "selected_radio_button" : "unselected_radio_button")
                Text(title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    RadioButtonView(title: "A very long line of text that will wrap if you let it.",
                    selected: .constant(true)
    )
}
