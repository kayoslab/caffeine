import Foundation
import UIKit
import Spring

class CaffeineInputButton: UIButton {
    @IBOutlet private weak var inputIcon: DesignableImageView?
    @IBOutlet private weak var selectIcon: SpringImageView?
    @IBOutlet private weak var descriptionLabel: UILabel?

    func tapAnimation(_ animated: Bool) {
        guard
            let selectIcon = self.selectIcon,
            let inputIcon = self.inputIcon
        else {
            return
        }

        selectIcon.isHidden = !selectIcon.isHidden
        backgroundColor = selectIcon.isHidden ? UIColor(
            red: 0.16,
            green: 0.16,
            blue: 0.17,
            alpha: 0
        ) : UIColor(
            red: 0.16,
            green: 0.16,
            blue: 0.17,
            alpha: 1
        )

        if animated == true {
            inputIcon.scaleX = 1.5
            inputIcon.scaleY = 1.5
            inputIcon.curve = "spring"
            inputIcon.duration = 1.2
            inputIcon.animate()

            selectIcon.animation = "fadeIn"
            selectIcon.curve = "spring"

            selectIcon.duration = 1.3
            selectIcon.animate()
        }
    }
}
