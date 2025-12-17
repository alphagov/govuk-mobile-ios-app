import SwiftUI
import GOVKit
import UIComponents
import MarkdownUI

struct ChatCellView: View {
    @StateObject private var viewModel: ChatCellViewModel

    init(viewModel: ChatCellViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.type {
            case .question:
                questionView
            case .pendingAnswer:
                pendingAnswerView
            case .answer:
                answerView
            case .intro:
                introView
            case .loading:
                questionView
            }
        }
        .background(viewModel.backgroundColor)
        .opacity(viewModel.isVisible ? 1 : 0)
        .scaleEffect(viewModel.scale, anchor: viewModel.anchor)
        .animation(.easeIn(duration: viewModel.duration).delay(viewModel.delay),
                   value: viewModel.isVisible)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.top, viewModel.topPadding)
        .contextMenu {
            Button(action: {
                viewModel.copyToClipboard()
            }, label: {
                Text(String.chat.localized("copyToClipboardTitle"))
                Image(systemName: "doc.on.doc.fill")
            })
        }
    }

    private var questionView: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(viewModel.message)
                .font(Font.govUK.body)
                .multilineTextAlignment(.leading)
                .padding()
                .accessibilityLabel(viewModel.accessibilityPrompt + viewModel.message)
        }
    }

    private var pendingAnswerView: some View {
        HStack(spacing: 5) {
            AnimatedAPNGImageView(imageName: "generating-your-answer")
                .frame(width: 24, height: 24)
            ChatEllipsesView(viewModel.message)
                .font(Font.govUK.body)
            Spacer()
        }
        .padding(.bottom)
    }

    private var introView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = viewModel.title {
                Text(title)
                    .font(Font.govUK.bodySemibold)
            }
            Text(viewModel.message)
                .font(Font.govUK.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private var answerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = viewModel.title {
                Text(title)
                    .font(Font.govUK.bodySemibold)
            }
            HStack(alignment: .firstTextBaseline) {
                markdownView
            }
            if !viewModel.sources.isEmpty {
                Divider()
                    .overlay(Color(UIColor.govUK.strokes.chatDivider))
                    .padding(.vertical, 8)
                warningView
                sourceView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private var sourceView: some View {
        VStack(alignment: .leading, spacing: 8) {
            DisclosureGroup {
                sourceListView
            } label: {
                Text(String.chat.localized("sourceListTitle"))
                    .foregroundColor(Color(UIColor.govUK.text.primary))
            }
        }
        .disclosureGroupStyle(
            ChatDisclosure(trackToggle: { isExpanded in
                viewModel.trackSourceListToggle(isExpanded: isExpanded)
            })
        ).padding(.top, 8)
    }

    private var warningView: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(Font.govUK.bodySemibold)
                .foregroundColor(Color(.govUK.text.trailingIcon))
                .accessibilityHidden(true)
            Text(String.chat.localized("mistakesTitle"))
                .font(Font.govUK.bodySemibold)
        }
    }

    private var markdownView: some View {
        Markdown(viewModel.message)
            .markdownTheme(Theme.govUK)
            .fixedSize(horizontal: false, vertical: true)
            .environment(\.openURL, OpenURLAction { url in
                viewModel.openURL(url: url, type: .responseLink)
                return .handled
            })
    }

    private var sourceListView: some View {
        ForEach(viewModel.sources, id: \.url) { source in
            Link(destination: source.urlWithFallback) {
                sourceListItemTitleView(title: source.title)
            }
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityHint(String.common.localized("openWebLinkHint"))
            .accessibilityRemoveTraits(.isButton)
            .environment(\.openURL, OpenURLAction { url in
                viewModel.openURL(url: url, type: .sourceLink)
                return .handled
            })
            Divider()
                .overlay(Color(UIColor.govUK.strokes.chatDivider))
                .opacity(source.url == viewModel.sources.last?.url ? 0 : 1)
        }
    }

    private func sourceListItemTitleView(title: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color(UIColor.govUK.text.link))
                .multilineTextAlignment(.leading)
                .padding(.top, 4)
            Spacer()
        }
    }
}

struct ChatDisclosure: DisclosureGroupStyle {
    var trackToggle: (Bool) -> Void

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            disclosureButtonView(configuration: configuration)
            if configuration.isExpanded {
                configuration.content
            }
        }
    }

    private func disclosureButtonView(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isExpanded.toggle()
                trackToggle(configuration.isExpanded)
            }
        } label: {
            HStack(alignment: .firstTextBaseline) {
                configuration.label
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: configuration.isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(Color(UIColor.govUK.text.link))
            }
        }
    }
}

#Preview {
    let previewMessage: String = """
        There are different ways to get a passport depending on whether it's
        your first adult passport or you're renewing an existing one.

        ## First adult passport

        You can apply online or with a paper form.

        Apply online

        1. costs £94.50
        2. you need a [digital photo][1], someone to confirm your identity,
          [supporting documents][2], and a credit or debit card
        3. [start your online application][3]

        ### Apply with a paper form

        * costs £107
        * you need a filled-in application form, 2 identical [printed passport
          photos][4], someone to confirm your identity (a 'countersignatory'),
          and [supporting documents][2]
        * get a paper form from a [Post Office that offers Check and Send
          service][5] or the [Passport Adviceline][6]
        * takes longer than applying online

        ## Renewing or replacing an existing passport

        You can [apply online for urgent passport services][7] if you need your
        passport quickly, or use the standard renewal process.

        [Check the full guidance on applying for a UK passport online][8] to
        find the right service for your situation.
        """

    ScrollView {
        VStack {
            ChatCellView(
                viewModel: ChatCellViewModel(
                    message: "What is your quest what is your",
                    id: UUID().uuidString,
                    type: .question)
            )
            ChatCellView(
                viewModel: ChatCellViewModel(
                    message: previewMessage,
                    id: UUID().uuidString,
                    type: .answer,
                    sources: [
                        Source(title: "Source 1", url: "https://www.example.com"),
                        Source(title: "Source 2", url: "https://www.other.com")
                    ])
            )
            ChatCellView(viewModel: .gettingAnswer)
        }
        .padding()
    }
}
