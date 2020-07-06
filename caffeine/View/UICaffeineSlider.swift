import Foundation
import UIKit

class UICaffeineSlider: UISlider {
    @IBOutlet private(set) weak var sliderPopupView: UISliderPopupView?

    internal var sliderType: SliderType? {
        didSet {
            minimumValue = sliderType?.sliderMin ?? 0.0
            maximumValue = sliderType?.sliderMax ?? 100.0
        }
    }

    internal func updateSliderPopup() {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 0
        guard let text = formatter.string(from: .init(value: value)) else { return }

        if (sliderType == SliderType.weight) {
            sliderPopupView?.setLabel(text: "\(text) kg")

        } else if (sliderType == SliderType.height) {
            sliderPopupView?.setLabel(text: "\(text) cm")

        } else if (sliderType == SliderType.sensibility) {
            sliderPopupView?.setLabel(text: "\(text) %")
        }
    }
}
