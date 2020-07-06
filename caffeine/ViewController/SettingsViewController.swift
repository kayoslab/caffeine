import Foundation
import UIKit

internal enum SliderType {
    case weight
    case height
    case sensibility
    case sex

    var sliderMin: Float {
        switch self {
        case .weight:
            return 0
        case .height:
            return 0
        case .sensibility:
            return 0
        case .sex:
            return 0
        }
    }

    var sliderMax: Float {
        switch self {
        case .weight:
            return 150
        case .height:
            return 225
        case .sensibility:
            return 100
        case .sex:
            return 100
        }
    }
}

/*
*
* Use this ViewController to modify the Personal data Values:
* - Weight
* - Body height
* - Gender
* - Caffeine Sensibility
* - oral contraceptives consumption
*
* Also use this Controller for pushing, when the Application is launched for
* the first time. All Data is Modified via a DataManager Object.
*
*
*/
class SettingsViewController: UIViewController {
    @IBOutlet private weak var weigthSlider: UICaffeineSlider?
    @IBOutlet private weak var heightSlider: UICaffeineSlider?
    @IBOutlet private weak var sensibilitySlider: UICaffeineSlider?
    @IBOutlet private weak var sexSlider: UICaffeineSlider?
    @IBOutlet private weak var oralContraceptivesSwitch: UISwitch?

    private var weightConst: NSLayoutConstraint = .init()
    private var heightConst: NSLayoutConstraint = .init()
    private var sensibilityConst: NSLayoutConstraint = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
    }

    private func setupSlider() {
        weigthSlider?.sliderType = .weight
        heightSlider?.sliderType = .height
        sensibilitySlider?.sliderType = .sensibility
        sexSlider?.sliderType = .sex

        weigthSlider?.value = Float(UserSettings.userWeight)
        heightSlider?.value = Float(UserSettings.userHeight)
        sensibilitySlider?.value = Float(UserSettings.userSensibility)
        sexSlider?.value = Float(UserSettings.userSex)
        oralContraceptivesSwitch?.setOn(UserSettings.userSteroids, animated: false)

        weightConst = NSLayoutConstraint(
            item: (weigthSlider?.sliderPopupView)!,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
        )
        heightConst = NSLayoutConstraint(
            item: (heightSlider?.sliderPopupView)!,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
        )
        sensibilityConst = NSLayoutConstraint(
            item: (sensibilitySlider?.sliderPopupView)!,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: view,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
        )

        view.addConstraint(weightConst)
        view.addConstraint(heightConst)
        view.addConstraint(sensibilityConst)
        updatePopup()
    }

    private func updatePopup() {
        weigthSlider?.updateSliderPopup()
        heightSlider?.updateSliderPopup()
        sensibilitySlider?.updateSliderPopup()

        weightConst.constant = getNewConstantPositionForSender(weigthSlider)
        heightConst.constant = getNewConstantPositionForSender(heightSlider)
        sensibilityConst.constant = getNewConstantPositionForSender(sensibilitySlider)
    }

    // TODO: Change Data via UserManager Class 
    // MARK: Slider and Button Actions

    @IBAction private func weightSliderValueChanged(_ sender: UICaffeineSlider) {
        sender.updateSliderPopup()
        weightConst.constant = self.getNewConstantPositionForSender(sender)
        UserSettings.userWeight = Int(round(sender.value))
    }

    @IBAction private func heightSliderValueChanged(_ sender: UICaffeineSlider) {
        sender.updateSliderPopup()
        heightConst.constant = self.getNewConstantPositionForSender(sender)
        UserSettings.userHeight = Int(round(sender.value))
    }

    @IBAction private func sensibilitySliderValueChaged(_ sender: UICaffeineSlider) {
        sender.updateSliderPopup()
        sensibilityConst.constant = self.getNewConstantPositionForSender(sender)
        UserSettings.userSensibility = Int(round(sender.value))
    }

    @IBAction private func sexSliderValueChaged(_ sender: UICaffeineSlider) {
        sender.updateSliderPopup()
        UserSettings.userSex = Int(round(sender.value))
    }

    @IBAction private func oralContraceptivesSwitchValueChanged(_ sender: UISwitch) {
        UserSettings.userSteroids = sender.isOn
    }

    private  func getNewConstantPositionForSender(_ sender: UICaffeineSlider?) -> CGFloat {
        guard let sender = sender else { return 0.0 }
        let valueMargin = sender.maximumValue - sender.minimumValue
        let differenceFromRefferencepoint = Double(sender.value - ((valueMargin / 2) + sender.minimumValue))
        let percentage: Double = differenceFromRefferencepoint / Double(valueMargin / 2)
        let sliderThumButtonWidth = 32.0
        let segment: Double = (Double(sender.bounds.width) - sliderThumButtonWidth) / 2
        return CGFloat(segment * percentage)
    }
}
