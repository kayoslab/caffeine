import Foundation
import UIKit
import Spring

/*
*
* Use this ViewController to call the "calculateHKValuesForSetup(coffee:Coffee, milk:Milk, size:Size, sugar:Sugar)"
* function on a ConsumptionObject. The user can select the designated drinks and a button is activated.
*
* TODO: Safe consumed Drinks of last 30 Days for statistical Purpose.
*
*/

class InputViewController: UIViewController {
    private var shotState: Coffee = .noShot
    private var milkState: Milk = .black
    private var cupState: Size = .noSize
    private var sugarState: Sugar = .noSugar

    private var shotSender: CaffeineInputButton?
    private var milkSender: CaffeineInputButton?
    private var cupSender: CaffeineInputButton?
    private var sugarSender: CaffeineInputButton?

    @IBOutlet private var inputOKButton: CaffeineInputOKButton?

    // MARK: Input Shot, Milk, Cupsize and Sugar IBActions
    @IBAction private func oneShotIconClicked(_ sender: CaffeineInputButton) {
        changeCoffeeState(sender, state: .singleShot)
    }

    @IBAction private func twoShotIconClicked(_ sender: CaffeineInputButton) {
        changeCoffeeState(sender, state: .doubleShot)
    }

    @IBAction private func threeShotIconClicked(_ sender: CaffeineInputButton) {
        changeCoffeeState(sender, state: .tripleShot)
    }

    @IBAction private func lactosefreeMilkIconClicked(_ sender: CaffeineInputButton) {
        changeMilkState(sender, state: .lactoseFree)
    }

    @IBAction private func wholeMilkIconClicked(_ sender: CaffeineInputButton) {
        changeMilkState(sender, state: .fullFat)
    }

    @IBAction private func soyMIlkIconClicked(_ sender: CaffeineInputButton) {
        changeMilkState(sender, state: .soyMilk)
    }

    @IBAction private func smallIconClicked(_ sender: CaffeineInputButton) {
        changeCupState(sender, state: .small)
    }

    @IBAction private func middleIconClicked(_ sender: CaffeineInputButton) {
        changeCupState(sender, state: .medium)
    }

    @IBAction private func largeIconClicked(_ sender: CaffeineInputButton) {
        changeCupState(sender, state: .large)
    }

    @IBAction private func oneSugarIconClicked(_ sender: CaffeineInputButton) {
        changeSugarState(sender, state: .singlePiece)
    }

    @IBAction private func twoSugarIconClicked(_ sender: CaffeineInputButton) {
        changeSugarState(sender, state: .twoPieces)
    }

    @IBAction private func threeSugarIconClicked(_ sender: CaffeineInputButton) {
        changeSugarState(sender, state: .threePieces)
    }

    @IBAction private func inputOKButtonClicked(_ sender: CaffeineInputOKButton) {
        // TODO: TapticEngine Vibration after Swift/iOS Update

        DrinksService.shared.drink(
            .init(
                coffee: shotState,
                milk: milkState,
                size: cupState,
                sugar: sugarState,
                date: .init()
            )
        )

        if shotState != .noShot {
            buttonTap(shotSender, animated: true)
            shotState = .noShot
        }
        if milkState != .black {
            buttonTap(milkSender, animated: true)
            milkState = .black
        }
        if cupState != .noSize {
            buttonTap(cupSender, animated: true)
            cupState = .noSize
        }
        if sugarState != .noSugar {
            buttonTap(sugarSender, animated: true)
            sugarState = .noSugar
        }
        checkInputOKButtonState()
    }

    // MARK: State Machine
    private func changeCoffeeState(_ sender: CaffeineInputButton, state: Coffee) {
        if shotState == .noShot {
            shotSender = sender
            shotState = state
        } else {
            if shotState == state {
                shotState = .noShot
            } else {
                buttonTap(shotSender)
                shotSender = sender
                shotState = state
            }
        }
        buttonTap(sender, animated: true)
        checkInputOKButtonState()
    }

    private func changeMilkState(_ sender: CaffeineInputButton, state: Milk) {
        if milkState == .black {
            milkSender = sender
            milkState = state
        } else {
            if milkState == state {
                milkState = .black
            } else {
                buttonTap(milkSender)
                milkSender = sender
                milkState = state
            }
        }
        buttonTap(sender, animated: true)
        checkInputOKButtonState()
    }

    private func changeCupState(_ sender: CaffeineInputButton, state: Size) {
        if cupState == .noSize {
            cupSender = sender
            cupState = state
        } else {
            if cupState == state {
                cupState = .noSize
            } else {
                buttonTap(cupSender)
                cupSender = sender
                cupState = state
            }
        }
        buttonTap(sender, animated: true)
        checkInputOKButtonState()
    }

    private func changeSugarState(_ sender: CaffeineInputButton, state: Sugar) {
        if sugarState == .noSugar {
            sugarSender = sender
            sugarState = state
        } else {
            if sugarState == state {
                sugarState = .noSugar
            } else {
                buttonTap(sugarSender)
                sugarSender = sender
                sugarState = state
            }
        }
        buttonTap(sender, animated: true)
        checkInputOKButtonState()
    }

    // Button Logic
    private func checkInputOKButtonState() {
        if shotState != .noShot {
            inputOKButton?.isSelectable = true
        } else {
            if milkState != .black && cupState != .noSize {
                inputOKButton?.isSelectable = true
            } else {
                inputOKButton?.isSelectable = false
            }
        }
    }

    // MARK: Button Tap handler

    private func buttonTap(_ sender: CaffeineInputButton?) {
        buttonTap(sender, animated: false)
    }

    private func buttonTap(_ sender: CaffeineInputButton?, animated: Bool) {
        guard let sender = sender else { return }

        sender.tapAnimation(animated)
    }
}
