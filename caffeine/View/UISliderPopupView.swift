import Foundation
import UIKit

class UISliderPopupView: UIView {
     @IBOutlet private weak var popUpLabel: UILabel?

    func setLabel(text: String?) {
        popUpLabel?.text = text
    }
}
