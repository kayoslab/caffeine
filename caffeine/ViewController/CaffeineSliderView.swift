import UIKit

@IBDesignable
class CaffeineSliderView: UIView, NibLoadable {
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var leadingLabel: UILabel?
    @IBOutlet private weak var trailingLabel: UILabel?
    @IBOutlet private weak var caffeineSlider: CaffeineSlider?

    private var positionConstant: NSLayoutConstraint = .init()
    private var heightConst: NSLayoutConstraint = .init()
    private var sensibilityConst: NSLayoutConstraint = .init()

    internal var sliderType: SliderType? {
        didSet {
            caffeineSlider?.sliderType = sliderType

            switch sliderType {
            case .weight:
                caffeineSlider?.value = Float(UserSettings.userWeight)
            case .height:
                caffeineSlider?.value = Float(UserSettings.userHeight)
            case .sensibility:
                caffeineSlider?.value = Float(UserSettings.userSensibility)
            case .sex:
                caffeineSlider?.value = Float(UserSettings.userSex)
            default:
                break
            }
            setupSlider()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupFromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        caffeineSlider?.sliderType = sliderType
        setupSlider()
    }

    @IBAction private func sliderValueChaged(_ sender: CaffeineSlider) {
        updatePopup()

        switch sliderType {
        case .weight:
            UserSettings.userWeight = Int(round(sender.value))
        case .height:
            UserSettings.userHeight = Int(round(sender.value))
        case .sensibility:
            UserSettings.userSensibility = Int(round(sender.value))
        case .sex:
            UserSettings.userSex = Int(round(sender.value))
        default:
            break
        }
    }


    private func setupSlider() {
        guard
            let popupView = caffeineSlider?.sliderPopupView,
            let sliderType = self.sliderType
        else { return }

        titleLabel?.text = sliderType.sliderTitle
        leadingLabel?.text = sliderType.sliderLeading
        trailingLabel?.text = sliderType.sliderTrailing

        if sliderType == .sex {
            popupView.isHidden = true
            return
        }

        positionConstant = NSLayoutConstraint(
            item: popupView,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
        )

        addConstraint(positionConstant)

        updatePopup()
    }

    private func updatePopup() {
        caffeineSlider?.updateSliderPopup()
        positionConstant.constant = getNewConstantPositionForSender(caffeineSlider)
    }

    private  func getNewConstantPositionForSender(_ sender: CaffeineSlider?) -> CGFloat {
        guard let sender = sender else { return 0.0 }

        let valueMargin = sender.maximumValue - sender.minimumValue
        let differenceFromRefferencepoint = Double(sender.value - ((valueMargin / 2) + sender.minimumValue))
        let percentage: Double = differenceFromRefferencepoint / Double(valueMargin / 2)
        let sliderThumButtonWidth = 32.0
        let segment: Double = (Double(sender.bounds.width) - sliderThumButtonWidth) / 2
        return CGFloat(segment * percentage)
    }
}
