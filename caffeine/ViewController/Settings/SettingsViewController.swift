import Foundation
import UIKit

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
    @IBOutlet private weak var weigthSlider: CaffeineSliderView?
    @IBOutlet private weak var heightSlider: CaffeineSliderView?
    @IBOutlet private weak var sensibilitySlider: CaffeineSliderView?
    @IBOutlet private weak var sexSlider: CaffeineSliderView?
    @IBOutlet private weak var oralContraceptivesSwitch: UISwitch?
    @IBOutlet private weak var medicalInformationButton: UIButton?


    @IBAction private func oralContraceptivesSwitchValueChanged(_ sender: UISwitch) {
        UserSettings.userSteroids = sender.isOn
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        weigthSlider?.sliderType = .weight
        heightSlider?.sliderType = .height
        sensibilitySlider?.sliderType = .sensibility
        sexSlider?.sliderType = .sex
        medicalInformationButton?.setTitle(L10n.settingsMedicalInformation, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        oralContraceptivesSwitch?.setOn(
            UserSettings.userSteroids,
            animated: animated
        )
    }
}
