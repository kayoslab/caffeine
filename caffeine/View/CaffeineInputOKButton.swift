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

@IBDesignable
class CaffeineInputOKButton: UIButton {

    @IBInspectable
    var isSelectable: Bool {
        didSet {
            if isSelectable {
                self.layer.borderColor = CaffeineColors.inputButton.color.cgColor
                self.isEnabled = true
            } else {
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.isEnabled = false
            }
        }
    }

    override init (frame: CGRect) {
        isSelectable = false
        super.init(frame: frame)

        setUpView()
    }


    required init?(coder aDecoder: NSCoder) {
        isSelectable = false
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
    }
}
