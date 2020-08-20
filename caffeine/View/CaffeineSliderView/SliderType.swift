import Foundation

internal enum SliderType {
    case weight
    case height
    case sensibility
    case sex

    var sliderMin: Float {
        switch self {
        case .weight:
            return 0
        case .height:
            return 0
        case .sensibility:
            return 0
        case .sex:
            return 0
        }
    }

    var sliderLeading: String {
        switch self {
        case .weight, .height, .sensibility:
            return unitString(value: sliderMin)
        case .sex:
            return L10n.settingsMale
        }
    }

    var sliderMax: Float {
        switch self {
        case .weight:
            return 150
        case .height:
            return 225
        case .sensibility:
            return 100
        case .sex:
            return 100
        }
    }

    var sliderTrailing: String {
        switch self {
        case .weight, .height, .sensibility:
            return unitString(value: sliderMax)
        case .sex:
            return L10n.settingsFemale
        }
    }

    var sliderTitle: String {
        switch self {
        case .weight:
            return L10n.settingsTitleWeight
        case .height:
            return L10n.settingsTitleHeight
        case .sensibility:
            return L10n.settingsTitleSensibility
        case .sex:
            return L10n.settingsTitleSex
        }
    }

    func unitString(value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 0
        guard let text = formatter.string(from: .init(value: value)) else { return "" }

        switch self {
        case .weight:
            return "\(text) kg"
        case .height:
            return "\(text) cm"
        case .sensibility:
            return "\(text) %"
        case .sex:
            return ""
        }
    }
}
