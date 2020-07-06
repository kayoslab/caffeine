import Foundation
import UIKit

class ConsumptionViewController: UIViewController {

    @IBOutlet private weak var todayCaffeineLabel: UILabel?
    @IBOutlet private weak var maximumCaffeineLabel: UILabel?

    @IBOutlet private weak var firstButton: UICaffeineConsumptionRecentButton?
    @IBOutlet private weak var secondButton: UICaffeineConsumptionRecentButton?
    @IBOutlet private weak var thirdButton: UICaffeineConsumptionRecentButton?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reloadData()

        HealthStoreService.shared.requestPermission { [weak self] in
            self?.reloadData()
        }
    }

    private func reloadData() {
        DispatchQueue.main.async(
            execute: { [weak self] () -> Void in
                let healthyAmount = Int(round(CaffeineDataService.shared.healthyAmount() ?? 0.0))
                self?.maximumCaffeineLabel?.text = "\(healthyAmount)"

                let recentConsumables = DrinksService.shared.getRecentDrinks()
                self?.firstButton?.setConsumable(recentConsumables[0])
                self?.secondButton?.setConsumable(recentConsumables[1])
                self?.thirdButton?.setConsumable(recentConsumables[2])
            }
        )

        CaffeineDataService.shared.getCaffeineConsumption { [weak self] (success, caffeineReturn) -> Void in
            guard success, let caffeineReturn = caffeineReturn else { return }
            DispatchQueue.main.async(
                execute: { () -> Void in
                    self?.todayCaffeineLabel?.text = "\(Int(round(caffeineReturn)))"
                }
            )
        }
    }

    @IBAction private func firstButtonTouchUpInside(_ sender: Any?) {
        recentButtonTouch(0)
    }

    @IBAction private func secondButtonTouchUpInside(_ sender: Any?) {
        recentButtonTouch(1)
    }

    @IBAction private func thirdButtonTouchUpInside(_ sender: Any?) {
        recentButtonTouch(2)
    }

    private func recentButtonTouch(_ recent: Int) {
        let recentConsumables = DrinksService.shared.getRecentDrinks()
        let recentConsumable = recentConsumables[recent]
        DrinksService.shared.drink(recentConsumable)

        let alertController = UIAlertController(
            title: "\(NSLocalizedString("ShortcutHeading", comment: ""))",
            message: NSLocalizedString("ShortcutText", comment: ""),
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: NSLocalizedString("ShortcutOK", comment: ""),
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)

        present(
            alertController,
            animated: true,
            completion: reloadData
        )
    }

}
