import SwiftUI

struct GroupedList: View {
    var content: [GroupedListSection] = GroupedListSection.previewContent

    var body: some View {
        ForEach(content, id: \.heading) { section in
            LazyVStack {
                Text(section.heading)
                    .font(Font.govUK.title3Semibold)

                ForEach(section.rows, id: \.title) { row in
                    Text(row.title)
                }
            }
            .padding()
        }
    }
}

#Preview {
    GroupedList()
}
