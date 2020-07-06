import UIKit

enum CaffeineColors {
    case consumptionButton
    case graph
    case inputButton
    case selectIcon
    case statsSeparatorStart
    case statsSeparatorEnd

    var color: UIColor {
        switch self {
        case .consumptionButton:
            return ColorScheme.primary.color
        case .graph:
            return ColorScheme.primary.color
        case .inputButton:
            return ColorScheme.secondary.color
        case .selectIcon:
            return ColorScheme.secondary.color
        case .statsSeparatorStart:
            return UIColor(red: 48.0 / 255.0, green: 48.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
        case .statsSeparatorEnd:
            return UIColor(red: 30.0 / 255.0, green: 29.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        }
    }
}

private enum ColorScheme {
    case primary
    case secondary
    case tertiary
    case quaternary
    case quinary
    case background

    var color: UIColor {
        switch self {
        case .primary:
            return HexColors.gold.color
        case .secondary:
            return HexColors.green.color
        case .tertiary:
            return HexColors.blue.color
        case .quaternary:
            return HexColors.pink.color
        case .quinary:
            return HexColors.purple.color
        case .background:
            return HexColors.darkGray.color
        }
    }
}

private enum HexColors: String {
    case gold = "FEEBB3"
    case green = "36D193"
    case blue = "B3FEFB"
    case pink = "FEB3F3"
    case purple = "B3B8FE"
    case darkGray = "35363A"

    var color: UIColor {
        return .init(hex: self.rawValue)
    }
}
