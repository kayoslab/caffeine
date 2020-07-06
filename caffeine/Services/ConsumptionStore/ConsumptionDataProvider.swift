import Foundation

/// A class conforming to this protocol provides stored lexicon data.
protocol ConsumptionDataProvider: class {

    func add(consumable: Consumable)

    func getRecentEntries() -> [Consumable]

    func getEntries(for period: Period) -> [Consumable]

    func clear() throws

}
