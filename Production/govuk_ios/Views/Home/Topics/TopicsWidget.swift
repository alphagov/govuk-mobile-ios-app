import SwiftUI
import UIComponents
import GOVKit

struct TopicsWidget: View {
    @StateObject var viewModel: TopicsWidgetViewModel

    var body: some View {
        if viewModel.fetchTopicsError {
            VStack {
                HStack {
                    Text(String.home.localized("topicsWidgetTitleCustomised"))
                        .font(Font.govUK.title3Semibold)
                    Spacer()
                }
                AppErrorView(
                    viewModel: self.viewModel.topicErrorViewModel
                )
                Spacer()
            }
            .padding(.horizontal)
        } else {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewModel.widgetTitle)
                            .font(Font.govUK.title3Semibold)
                            .foregroundColor(Color(UIColor.govUK.text.primary))
                            .padding([.leading], 4)
                        Spacer()
                        Button(
                            action: {
                                
                            }, label: {
                                Text(viewModel.editButtonTitle)
                                    .foregroundColor(
                                        Color(UIColor.govUK.text.buttonSecondary)
                                    )
                                    .font(Font.govUK.subheadlineSemibold)
                            }
                        )
                    }
                    VStack {

                    }
                }
            }
        }
    }
}
