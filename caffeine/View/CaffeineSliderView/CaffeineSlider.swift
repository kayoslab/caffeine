import Foundation
import UIKit

class CaffeineSlider: UISlider {
    @IBOutlet private(set) weak var sliderPopupView: SliderPopupView?

    internal var sliderType: SliderType? {
        didSet {
            minimumValue = sliderType?.sliderMin ?? 0.0
            maximumValue = sliderType?.sliderMax ?? 100.0
        }
    }

    internal func updateSliderPopup() {
        sliderPopupView?.setLabel(text: sliderType?.unitString(value: value))
    }
}
