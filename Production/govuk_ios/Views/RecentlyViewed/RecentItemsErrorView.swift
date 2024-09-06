import SwiftUI

struct RecentItemsErrorView: View {
    var model: RecentItemsErrorStructure
    var body: some View {
        VStack {
            Text(model.errorTitle).bold()
            Text(model.errrorDesc)
            Spacer()
        }.padding()
    }
}
