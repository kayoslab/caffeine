import Foundation

struct Consumable: Codable, Equatable {
    let coffee: Coffee
    let milk: Milk
    let size: Size
    let sugar: Sugar
    let date: Date

    static let defaultRecentDrinks: [Consumable] = [
        .init(
            coffee: .doubleShot,
            milk: .fullFat,
            size: .small,
            sugar: .twoPieces,
            date: .init()
        ), .init(
            coffee: .singleShot,
            milk: .soyMilk,
            size: .medium,
            sugar:. singlePiece,
            date: .init()
        ), .init(
            coffee: .tripleShot,
            milk: .lactoseFree,
            size: .large,
            sugar: .noSugar,
            date: .init()
        )
    ]
}

enum Coffee: Int, Codable {
    case noShot
    case singleShot
    case doubleShot
    case tripleShot

    var localizedTitle: String {
        switch self {
        case .noShot:
            return L10n.noshot
        case .singleShot:
            return L10n.singleshot
        case .doubleShot:
            return L10n.doubleshot
        case .tripleShot:
            return L10n.tripleshot
        }
    }
}

enum Milk: Int, Codable {
    case black
    case lactoseFree
    case fullFat
    case soyMilk

    var localizedTitle: String {
        switch self {
        case .black:
            return L10n.black
        case .lactoseFree:
            return L10n.lactosefree
        case .fullFat:
            return L10n.fullfat
        case .soyMilk:
            return L10n.soymilk
        }
    }
}

enum Size: Int, Codable {
    case noSize
    case small
    case medium
    case large

    var localizedTitle: String {
        switch self {
        case .noSize:
            return L10n.nosize
        case .small:
            return L10n.small
        case .medium:
            return L10n.medium
        case .large:
            return L10n.large
        }
    }

    var imageName: String {
        switch self {
        case .noSize:
            return "quickShot"
        case .small:
            return "quickSmall"
        case .medium:
            return "quickMedium"
        case .large:
            return "quickLarge"
        }
    }

    var imageNameSelected: String {
        switch self {
        case .noSize:
            return "quickShotPressed"
        case .small:
            return "quickSmallPressed"
        case .medium:
            return "quickMediumPressed"
        case .large:
            return "quickLargePressed"
        }
    }
}

enum Sugar: Int, Codable {
    case noSugar
    case singlePiece
    case twoPieces
    case threePieces

    var localizedTitle: String {
        switch self {
        case .noSugar:
            return L10n.nosugar
        case .singlePiece:
            return L10n.singlepiece
        case .twoPieces:
            return L10n.twopiece
        case .threePieces:
            return L10n.threepiece
        }
    }
}
