import Foundation
import UIKit

class UICaffeineConsumptionRecentButton: UIButton {
    @IBOutlet private weak var cupIcon: UIImageView!
    @IBOutlet private weak var mainLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    internal var shotState: Coffee = .noShot
    internal var milkState: Milk = .black
    internal var cupState: Size = .noSize
    internal var sugarState: Sugar = .noSugar

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
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 0.0
        self.layer.borderColor = CaffeineColors.consumptionButton.color.cgColor
    }

    func setConsumable(_ consumable: Consumable) {
        shotState = consumable.coffee
        milkState = consumable.milk
        cupState = consumable.size
        sugarState = consumable.sugar

        setRecentButtonAppearance()
    }

    fileprivate func setRecentButtonAppearance() {
        self.mainLabel.text = "\(shotState.localizedTitle), \(cupState.localizedTitle)"
        self.subtitleLabel.text = "\(milkState.localizedTitle), \(sugarState.localizedTitle)"
        self.cupIcon.image = UIImage(named: cupState.imageName)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.mainLabel.textColor = UIColor.darkGray
        self.subtitleLabel.textColor = UIColor.darkGray
        self.cupIcon.image = UIImage(named: cupState.imageNameSelected)
        self.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        self.mainLabel.textColor = CaffeineColors.consumptionButton.color
        self.subtitleLabel.textColor = UIColor.white
        self.cupIcon.image = UIImage(named: cupState.imageName)
        self.layer.borderColor = CaffeineColors.consumptionButton.color.cgColor
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        self.mainLabel.textColor = CaffeineColors.consumptionButton.color
        self.subtitleLabel.textColor = UIColor.white
        self.cupIcon.image = UIImage(named: cupState.imageName)
        self.layer.borderColor = CaffeineColors.consumptionButton.color.cgColor
    }

}
