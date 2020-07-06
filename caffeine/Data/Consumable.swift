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
        switch(self) {
        case .noShot:
            return NSLocalizedString("noshot", comment: "")
        case .singleShot:
            return NSLocalizedString("singleshot", comment: "")
        case .doubleShot:
            return NSLocalizedString("doubleshot", comment: "")
        case .tripleShot:
            return NSLocalizedString("tripleshot", comment: "")
        }
    }
}

enum Milk: Int, Codable {
    case black
    case lactoseFree
    case fullFat
    case soyMilk

    var localizedTitle: String {
        switch(self) {
        case .black:
            return NSLocalizedString("black", comment: "")
        case .lactoseFree:
            return NSLocalizedString("lactosefree", comment: "")
        case .fullFat:
            return NSLocalizedString("fullfat", comment: "")
        case .soyMilk:
            return NSLocalizedString("soymilk", comment: "")
        }
    }
}

enum Size: Int, Codable {
    case noSize
    case small
    case medium
    case large

    var localizedTitle: String {
        switch(self) {
        case .noSize:
            return NSLocalizedString("nosize", comment: "")
        case .small:
            return NSLocalizedString("small", comment: "")
        case .medium:
            return NSLocalizedString("medium", comment: "")
        case .large:
            return NSLocalizedString("large", comment: "")
        }
    }

    var imageName: String {
        switch(self) {
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
        switch(self) {
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
        switch(self) {
        case .noSugar:
            return NSLocalizedString("nosugar", comment: "")
        case .singlePiece:
            return NSLocalizedString("singlepiece", comment: "")
        case .twoPieces:
            return NSLocalizedString("twopiece", comment: "")
        case .threePieces:
            return NSLocalizedString("threepiece", comment: "")
        }
    }
}
