import Foundation
import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

class UICaffeineInputOKButton: UIButton {

    override init (frame: CGRect) {
        super.init(frame: frame)

        setUpView()
    }

    convenience init () {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUpView()
    }

    fileprivate func setUpView() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0

        setTitleColor(UIColor.lightGray, for: .disabled)
        setTitleColor(CaffeineColors.inputButton.color, for: .highlighted)
        setBackgroundImage(UIColor.clear.image(), for: .disabled)
        setBackgroundImage(UIColor.clear.image(), for: .highlighted)

        makeButtonNotSelectable()
    }

    internal func makeButtonSelectable() {
        self.layer.borderColor = CaffeineColors.inputButton.color.cgColor
        self.isEnabled = true
    }

    internal func makeButtonNotSelectable() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.isEnabled = false
    }
}
