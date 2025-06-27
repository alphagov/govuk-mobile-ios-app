import SwiftUI
import GOVKit
import UIComponents

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID

    init(viewModel: ChatViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(viewModel.cellModels, id: \.id) { cellModel in
                            HStack {
                                if !cellModel.isAnswer {
                                    Spacer(minLength: cellModel.questionWidth)
                                }
                                ChatCellView(viewModel: cellModel)
                                    .padding(.vertical, 4)
                            }
                        }
                        Text("")
                            .id(bottomID)
                    }
                    .onChange(of: viewModel.scrollToBottom) { shouldScroll in
                        if shouldScroll {
                            withAnimation {
                                proxy.scrollTo(bottomID, anchor: .bottom)
                            }
                            viewModel.scrollToBottom = false
                        }
                    }
                }
                Spacer()
                Divider()
                HStack {
                    TextField("", text: $viewModel.latestQuestion)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.questionInProgress)
                        .layoutPriority(2.0)
                    SwiftUIButton(.compact,
                                  viewModel: viewModel.sendButtonViewModel)
                    .disabled(viewModel.questionInProgress || viewModel.latestQuestion.isEmpty)
                    .layoutPriority(1.0)
                    .frame(minWidth: 100)
                }
            }
            .padding()
        }
    }
}
