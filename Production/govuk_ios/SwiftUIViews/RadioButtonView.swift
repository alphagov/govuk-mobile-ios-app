import SwiftUI
import GOVKit
import UIComponents

struct RadioButtonView: View {
    @Binding var selected: Bool
    var isLastRow: Bool
    var title: String

    init(title: String,
         selected: Binding<Bool>,
         isLastRow: Bool) {
        self.title = title
        _selected = selected
        self.isLastRow = isLastRow
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(selected ? "selected_radio_button" : "unselected_radio_button")
                Text(title)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                    .font(.body)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(title + (selected ? ", selected" : ""))
            Divider()
                .opacity(isLastRow ? 0 : 1)
                .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RadioButtonView(title: "APPLETREE COTTAGE, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
                    selected: .constant(false),
                    isLastRow: false
    )
    RadioButtonView(title: "ASHLEA, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
                    selected: .constant(true),
                    isLastRow: false
    )
    RadioButtonView(title: "UNIT 1, BARNES BUSINESS, BARRACK ROAD, WEST PARLEY, BH22 8UB",
                    selected: .constant(false),
                    isLastRow: true
    )
}
