import UIKit

// Statistics Setup
internal let intersectDistance: [Int] = [4, 1, 5, 61]
internal let catmullRomSelection: [Bool] = [true, false, true, false]

enum ShortcutItem: String {
    case first = "caffeine.shortcut.first"
    case second = "caffeine.shortcut.second"
    case third = "caffeine.shortcut.third"

    var consumable: Consumable {
        let recentDrinks = DrinksService.shared.getRecentDrinks()
        switch self {
        case .first:
            return recentDrinks[0]
        case .second:
            return recentDrinks[1]
        case .third:
            return recentDrinks[2]
        }
    }

    var shortcutItem: UIMutableApplicationShortcutItem? {
        return .init(
            type: self.rawValue,
            localizedTitle: consumable.coffee.localizedTitle,
            localizedSubtitle: "\(consumable.milk.localizedTitle), \(consumable.sugar.localizedTitle)",
            icon: UIApplicationShortcutIcon(templateImageName: consumable.size.imageName),
            userInfo: [:] as [String: NSSecureCoding]
        )
    }
}

// MARK: Begin AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    /// A storage provider to be accessed by core data relevant classes.
    lazy internal var datastoreProvider: DatastoreProvider = {
        return DatastoreProvider()
    }()

    /// A context provider to be accessed by core data relevant classes.
    lazy internal var contextProvider: ContextProvider = {
        return ContextProvider(with: datastoreProvider)
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setShortcutItems(application)
        return true
    }

    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }

    func handleShortCutItem(
        _ shortcutItem: UIApplicationShortcutItem
    ) -> Bool {
        guard let shortcutItem = ShortcutItem(rawValue: shortcutItem.type) else { return false }

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

        // Store the drink with a new date.
        DrinksService.shared.drink(
            .init(
                coffee: shortcutItem.consumable.coffee,
                milk: shortcutItem.consumable.milk,
                size: shortcutItem.consumable.size,
                sugar: shortcutItem.consumable.sugar,
                date: .init()
            )
        )
        window?.rootViewController?.present(
            alertController,
            animated: true,
            completion: nil
        )
        return true
    }

    internal func setShortcutItems(_ application: UIApplication) {
        application.shortcutItems = [
            ShortcutItem.first.shortcutItem,
            ShortcutItem.second.shortcutItem,
            ShortcutItem.third.shortcutItem
        ].compactMap { $0 }
    }
}
