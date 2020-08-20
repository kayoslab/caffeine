import Foundation
import UIKit

class SliderPopupView: UIView {
     @IBOutlet private weak var popUpLabel: UILabel?

    func setLabel(text: String?) {
        popUpLabel?.text = text
    }
}
