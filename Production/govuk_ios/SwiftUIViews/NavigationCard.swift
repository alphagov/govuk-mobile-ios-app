import SwiftUI
import UIComponents

struct NavigationCard: View,
                       NavigationCardType {
    let type: NavigationType
    let model: NavigationCardModel

    init(type: NavigationType,
         model: NavigationCardModel) {
        self.type = type
        self.model = model
    }

    enum NavigationType {
        case leftImageCard
        case rightImageCard
        case verticalImageCard
        case plainTextCard
    }

    var body: some View {
        switch self.type {
        case .leftImageCard:
            LeftNavigationCard(model: model)
        case .rightImageCard:
            RightNavigationCard(model: model)
        case .verticalImageCard:
            VerticalNavigationCard(model: model)
        case .plainTextCard:
            PlainNavigationCard(model: model)
        }
    }
}

struct VerticalNavigationCard: View,
                               NavigationCardType {
    let model: NavigationCardModel
    var body: some View {
        VStack {
            VStack {
                Image(model.image)
                    .resizable()
                    .scaledToFit()
                    .background(Color.blue)
            }.overlay(alignment: .topTrailing) {
                Image(systemName: "xmark")
                    .padding(4)
            }
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(Font.govUK.title1)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Text(model.primaryDescritpion)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Text(model.secondaryDescription)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Text(model.link)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.link))
            }
        }.background(Color(uiColor: UIColor.green))
            .roundedBorder(
                cornerRadius: 10,
                borderColor: Color(uiColor: .blue),
                borderWidth: 1
            )
            .padding()
    }
}

struct PlainNavigationCard: View,
                            NavigationCardType {
    let model: NavigationCardModel
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(Font.govUK.bodySemibold)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Text(model.primaryDescritpion)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Text(model.secondaryDescription)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.primary))
                Text(model.link)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.link))
            }
            Button(action: {}, label: {
                VStack {
                    Image(systemName: "xmark")
                }.padding()
            })
        }.padding()
            .background(Color(uiColor: UIColor.green))
            .roundedBorder(
                cornerRadius: 10,
                borderColor: Color(uiColor: .blue),
                borderWidth: 1
            )
            .padding()
    }
}

struct LeftNavigationCard: View,
                           NavigationCardType {
    let model: NavigationCardModel
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(model.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 210)
                    .background(Color.blue)
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading) {
                            Text(model.title)
                                .font(Font.govUK.bodySemibold)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                            Text(model.primaryDescritpion)
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                            Text(model.secondaryDescription)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                                .font(Font.govUK.body)
                            Text(model.link)
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.link))
                        }
                        Button(action: {}, label: {
                            VStack {
                                Image(systemName: "xmark")
                            }.padding()
                        })
                    }.padding(2)
                }
            }
        }
        .background(Color(uiColor: UIColor.green))
        .roundedBorder(
            cornerRadius: 10,
            borderColor: Color(uiColor: .blue),
            borderWidth: 1
        )
        .padding()
    }
}

struct RightNavigationCard: View,
                            NavigationCardType {
    let model: NavigationCardModel
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(model.title)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(Font.govUK.bodySemibold)
                    Text(model.primaryDescritpion)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                    Text(model.secondaryDescription)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(Font.govUK.body)
                    Text(model.link)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.link))
                }.padding()
                VStack {
                    Image(model.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 210)
                        .background(Color.blue)
                }.overlay(alignment: .topTrailing) {
                    Button(action: {}, label: {
                        VStack {
                            Image(systemName: "xmark")
                        }.padding()
                    })
                    }
                }
            }

        .background(Color(uiColor: UIColor.green))
        .roundedBorder(
            cornerRadius: 10,
            borderColor: Color(uiColor: .blue),
            borderWidth: 1
        )
        .padding()
    }
}

struct NavigationCardModel {
    let dissmissAction: () -> Void
    let image: String
    let title: String
    let primaryDescritpion: String
    let secondaryDescription: String
    let link: String
}
protocol NavigationCardType { }
