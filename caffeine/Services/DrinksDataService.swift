import Foundation

class DrinksService {
    static var sharedInstance: DrinksService = .init()

    private var recentDrinksURL: URL? {
        guard let documentDirectoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { return nil }
        return documentDirectoryUrl.appendingPathComponent("recent_drinks.json")
    }

    func drink(_ consumable: Consumable) {
        ConsumptionStore.shared.add(consumable: consumable)
        HealthStoreService.shared.storeConsumedObjectIntoHealth(
            .init(consumable)
        )
    }

    internal func getRecentDrinks() -> [Consumable] {
        var recent = ConsumptionStore.shared.getRecentEntries()

        // If there are too few recent drinks we can take them from
        // the default recent drinks in the consumable object
        for index in 0..<Consumable.defaultRecentDrinks.count {
            if recent.count < Consumable.defaultRecentDrinks.count {
                recent.append(Consumable.defaultRecentDrinks[index])
            }
        }

        return recent
    }
}
