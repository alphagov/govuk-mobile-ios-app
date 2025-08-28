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
                    .foregroundColor(Color(UIColor.govUK.text.primary))
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
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                Text(model.link)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.link))
            }
        }.background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
            .roundedBorder()
            .shadow(
                color: Color(uiColor: UIColor.govUK.fills.surfaceBackground),
                radius: 0, x: 0, y: 3
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
                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                Text(model.link)
                    .font(Font.govUK.body)
                    .foregroundColor(Color(UIColor.govUK.text.link))
            }
            Button(action: {
                model.dismissAction()
            }, label: {
                VStack {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
                }.padding()
            })
        }.padding()
            .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
            .roundedBorder(borderColor: .clear)
            .shadow(
                color: Color(
                    uiColor: UIColor.govUK.fills.surfaceBackground
                ),
                radius: 0, x: 0, y: 3
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
//                    .frame(width: 100, height: 188)
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(model.title)
                                .font(Font.govUK.bodySemibold)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                            Text(model.primaryDescritpion)
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.primary))
                            Text(model.secondaryDescription)
                                .foregroundColor(Color(UIColor.govUK.text.secondary))
                                .font(Font.govUK.body)
                            Text(model.link)
                                .font(Font.govUK.body)
                                .foregroundColor(Color(UIColor.govUK.text.link))
                        }
                        Button(action: {
                            model.dismissAction()
                        }, label: {
                            VStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.govUK.text.secondary))
                            }.padding()
                        })
                    }.padding(2)
                }
            }
        }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
        .roundedBorder(borderColor: .clear)
        .shadow(color: Color(uiColor: UIColor.green), radius: 0, x: 0, y: 3)
        .padding()
    }
}

struct RightNavigationCard: View,
                            NavigationCardType {
    let model: NavigationCardModel
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(model.title)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                        .font(Font.govUK.bodySemibold)
                    Text(model.primaryDescritpion)
                        .font(Font.govUK.body)
                        .foregroundColor(Color(UIColor.govUK.text.primary))
                    Text(model.secondaryDescription)
                        .foregroundColor(Color(UIColor.govUK.text.secondary))
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
                }.overlay(alignment: .topTrailing) {
                    Button(action: {
                        model.dismissAction()
                    }, label: {
                        VStack {
                            Image(systemName: "xmark")
                                .foregroundColor(Color(UIColor.govUK.text.secondary))
                        }.padding()
                    })
                    }
                }
            }
        .background(Color(uiColor: UIColor.govUK.fills.surfaceBackground))
        .roundedBorder(borderColor: .clear)
        .shadow(color: Color(uiColor: UIColor.green), radius: 0, x: 0, y: 3)
        .padding()
    }
}

struct NavigationCardModel {
    let dismissAction: () -> Void
    let image: String
    let title: String
    let primaryDescritpion: String
    let secondaryDescription: String
    let link: String
}
protocol NavigationCardType { }
