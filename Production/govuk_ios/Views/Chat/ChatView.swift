import SwiftUI
import GOVKit
import UIComponents

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            backgroundGradient
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.horizontal)

            chatCellsScrollViewReaderView
                .frame(maxHeight: .infinity)

            topAndBottomBlurGradientView

            VStack {
                Spacer()
                textFieldQuestionView
            }
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }

    private var chatCellsView: some View {
        ForEach(viewModel.cellModels, id: \.id) { cellModel in
            HStack {
                if !cellModel.isAnswer {
                    Spacer(minLength: cellModel.questionWidth)
                }
                ChatCellView(viewModel: cellModel)
                    .padding(.vertical, 4)
            }
        }
    }

    private var chatCellsScrollViewReaderView: some View {
        ScrollViewReader { proxy in
            chatCellsScrollView(proxy: proxy)
        }
        .padding(.horizontal)
    }

    private func chatCellsScrollView(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            chatCellsView
            Text("")
                .id(bottomID)
            Rectangle()
                .fill(Color.clear)
                .frame(height: 80)
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

    private var textFieldQuestionView: some View {
        HStack {
            Menu {
                Button(role: .destructive, action: clearChat) {
                    Label("Clear chat", systemImage: "trash")
                }
                Button(action: showAbout) {
                    Label("About", systemImage: "info.circle")
                }
            } label: {
                HStack {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(UIColor.govUK.text.buttonSecondary))
                }
                .background(
                    Circle()
                        .fill(Color(UIColor.govUK.fills.surfaceChatAnswer))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(
                                    Color(UIColor.govUK.strokes.listDivider),
                                    lineWidth: 1
                                )
                        )
                )
            }
            .padding(16)

            TextField("", text: $viewModel.latestQuestion)
                .disabled(viewModel.questionInProgress)
                .layoutPriority(2.0)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color(UIColor.govUK.fills.surfaceChatAnswer))
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color(UIColor.govUK.strokes.listDivider), lineWidth: 1)
                            )
                    }
                )
            SwiftUIButton(.compact,
                          viewModel: viewModel.sendButtonViewModel)
            .disabled(viewModel.questionInProgress || viewModel.latestQuestion.isEmpty)
            .layoutPriority(1.0)
            .frame(minWidth: 100)
        }
        .padding()
    }

    private var backgroundGradient: LinearGradient {
        let backgroundColor = Color(UIColor.govUK.fills.surfaceChatBackground)
        return LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.clear, location: 0),
                .init(color: backgroundColor, location: 0.2),
                .init(color: backgroundColor, location: 0.6),
                .init(color: Color.clear, location: 1)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var topAndBottomBlurGradientView: some View {
        VStack {
            let blurColor = Color(UIColor.govUK.fills.surfaceBackground)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(
                        color: blurColor.opacity(1),
                        location: 0
                    ),
                    .init(
                        color: blurColor.opacity(0.7),
                        location: 0.8
                    ),
                    .init(
                        color: blurColor.opacity(0),
                        location: 1
                    )
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            .frame(height: 20)

            Spacer()

            LinearGradient(
                gradient: Gradient(stops: [
                    .init(
                        color: blurColor.opacity(0),
                        location: 0
                    ),
                    .init(
                        color: blurColor.opacity(0.7),
                        location: 0.2
                    ),
                    .init(
                        color: blurColor.opacity(1),
                        location: 1
                    )
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .horizontal)
            .frame(height: 90)
        }
    }

    func showAbout() {
        // Implement your about logic here
        print("About tapped")
    }

    func clearChat() {
        // Implement your about logic here
        print("Clear chat")
    }
}
