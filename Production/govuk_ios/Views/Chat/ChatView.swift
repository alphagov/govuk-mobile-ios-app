import SwiftUI
import GOVKit
import UIComponents
import UIKit

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Namespace var bottomID
    @FocusState private var textAreaFocused: Bool
    @State private var textViewHeight: CGFloat = 50.0

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

            textFieldQuestionView
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
        GeometryReader { geom in
            let maxTextEditorFrameHeight = geom.size.height - geom.safeAreaInsets.top
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    if !textAreaFocused {
                        Menu {
                            Button(role: .destructive, action: clearChat) {
                                Label("Clear chat", systemImage: "trash")
                            }
                            Button(action: showAbout) {
                                Label("About", systemImage: "info.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(Color(UIColor.govUK.text.buttonSecondary))
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(Color(UIColor.govUK.fills.surfaceChatAnswer))
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    Color(UIColor.govUK.strokes.listDivider),
                                                    lineWidth: 1
                                                )
                                        )
                                )
                        }
                    }

                    ZStack(alignment: .bottom) {
                        DynamicTextEditor(
                            text: $viewModel.latestQuestion, dynamicHeight: $textViewHeight
                        )
                        .focused($textAreaFocused)
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .frame(height: min(textEditorFrameHeight, maxTextEditorFrameHeight))
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(UIColor.govUK.fills.surfaceChatAnswer))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(
                                            Color(UIColor.govUK.strokes.listDivider),
                                                lineWidth: 1
                                            )
                                    )
                            )
                    }
                    .animation(.easeInOut(duration: 0.3), value: textViewHeight)
                    .animation(.easeInOut(duration: 0.3), value: textAreaFocused)
                }
                .padding()
            }
            .frame(height: geom.size.height, alignment: .bottom)
        }
    }

    private var textEditorFrameHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let lineHeight = font.lineHeight
        return textAreaFocused ? textViewHeight + (2 * lineHeight) : 50
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
        print("About tapped")
    }

    func clearChat() {
        print("Clear chat")
    }
}

struct TextHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 50
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
