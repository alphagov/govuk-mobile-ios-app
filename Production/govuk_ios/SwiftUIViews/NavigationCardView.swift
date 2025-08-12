import SwiftUI

struct LeftNavigationCardView: View,
                               NavigationCard {
    let model: NavigationCardModel
    var body: some View {
        HStack {
            VStack {
                Image(systemName: model.image)
            }
            VStack {
                HStack {
                    Text(model.title)
                    Button(action: {
                        model.dissmissAction()
                    }, label: {
                        Image(systemName: "cross")
                    })
                }
                Text(model.primaryDescritpion)
                Text(model.secondaryDescription)
                Text(model.link)
            }
        }
    }
}

struct RightNavigationCardView: View,
                                NavigationCard {
    let model: NavigationCardModel
    var body: some View {
        HStack {
            VStack {
                Image(systemName: model.image)
            }
            VStack {
                Text(model.title)
                Text(model.primaryDescritpion)
                Text(model.secondaryDescription)
                Text(model.link)
            }
        }
    }
}

struct VerticalNavigationCardView: View,
                                   NavigationCard {
    let model: NavigationCardModel
    var body: some View {
        HStack {
            VStack {
                Image(systemName: model.image)
            }
            VStack {
                Text(model.title)
                Text(model.primaryDescritpion)
                Text(model.secondaryDescription)
                Text(model.link)
            }
        }
    }
}

struct NavigationCardBuilder {
    enum CardView {
        case left
        case right
        case big
    }

    func returnNavigationCardView(model: NavigationCardModel, config: CardView) -> NavigationCard {
        switch config {
        case .left:
            return LeftNavigationCardView(model: model)
        case .right:
            return RightNavigationCardView(model: model)
        case .big:
            return VerticalNavigationCardView(model: model)
        }
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

protocol NavigationCard { }
