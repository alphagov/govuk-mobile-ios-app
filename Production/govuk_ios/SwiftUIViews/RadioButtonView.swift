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
                Image(systemName: selected ? "circle.fill" : "circle")
                Text(title)
            }
        }
        .padding()
    }
}

#Preview {
    RadioButtonView(title: "A very long line of text that will wrap if you let it.",
                    selected: .constant(true)
    )
}
