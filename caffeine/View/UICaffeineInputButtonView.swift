import Foundation
import UIKit

class UICaffeineInputButtonView: UIView {

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

    func setUpView () {

    }
}
