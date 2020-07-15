import Foundation
import CoreData

/// A data store for lexicon entries. This can be used to locally persist any type of entries.
/// The `ConsumptionStore` follows the singleton pattern and should be accessed
/// via the .shared property.
final class ConsumptionStore: NSObject {

     /// A static singleton reference.
    public static var shared: ConsumptionStore = .init()

    /// The context in which we are manipulating the local database
    private var mainContextInstance: NSManagedObjectContext

    /// Private initialiser to enforce the singleton pattern.
    override private init() {
        mainContextInstance = PersistenceService.shared.getMainContextInstance()
    }
}

// MARK: - Sessions

extension ConsumptionStore: ConsumptionDataProvider {

    func add(consumable: Consumable) {
        let minionManagedObjectContextWorker: NSManagedObjectContext = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        minionManagedObjectContextWorker.parent = mainContextInstance
        minionManagedObjectContextWorker.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        minionManagedObjectContextWorker.performAndWait {
            let newEntry = Consumption(context: minionManagedObjectContextWorker)

            newEntry.date = consumable.date
            newEntry.coffee = .init(consumable.coffee.rawValue)
            newEntry.milk = .init(consumable.milk.rawValue)
            newEntry.size = .init(consumable.size.rawValue)
            newEntry.sugar = .init(consumable.sugar.rawValue)

            PersistenceService.shared.saveWorkerContext(minionManagedObjectContextWorker)
            PersistenceService.shared.mergeWithMainContext()
        }
    }

    func getRecentEntries() -> [Consumable] {
        let fetchRequest: NSFetchRequest<Consumption> = Consumption.fetchRequest()
        fetchRequest.fetchLimit = 3
        fetchRequest.sortDescriptors = [.init(key: "date", ascending: false)]

        guard let entries = try? mainContextInstance.fetch(fetchRequest)
            .sorted(by: { $0.date ?? .init() < $1.date ?? .init() })
        else {
            return []
        }

        return entries
            .compactMap {
                guard
                    let coffee = Coffee(rawValue: Int($0.coffee)),
                    let milk = Milk(rawValue: Int($0.milk)),
                    let size = Size(rawValue: Int($0.size)),
                    let sugar = Sugar(rawValue: Int($0.sugar)),
                    let date = $0.date
                else {
                    return nil
                }
                return Consumable(
                    coffee: coffee,
                    milk: milk,
                    size: size,
                    sugar: sugar,
                    date: date
                )
            }
            .reversed()
    }

    func getEntries(for period: Period) -> [Consumable] {
        let fetchRequest: NSFetchRequest<Consumption> = Consumption.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "date", ascending: true)]

        switch period {
        case .day:
            let startOfDay = Calendar.current.startOfDay(for: .init())
            let endOfDay = startOfDay.addingTimeInterval(Period.day.inSeconds)
            fetchRequest.predicate = NSPredicate(
                format: "date >= %@ && date <= %@",
                startOfDay as NSDate,
                endOfDay as NSDate
            )

            break
        case .week:
            guard let startOfWeek = Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: .init()
                )
            ) else { return [] }
            let endOfWeek = startOfWeek.addingTimeInterval(Period.week.inSeconds)
            fetchRequest.predicate = NSPredicate(
                format: "date >= %@ && date <= %@",
                startOfWeek as NSDate,
                endOfWeek as NSDate
            )

            break
        case .month:
            guard let startOfMonth = Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year, .month],
                    from: .init()
                )
            ) else { return [] }
            let endOfMonth = startOfMonth.addingTimeInterval(Period.month.inSeconds)
            fetchRequest.predicate = NSPredicate(
                format: "date >= %@ && date <= %@",
                startOfMonth as NSDate,
                endOfMonth as NSDate
            )

            break
        case .year:
            guard let startOfYear = Calendar.current.date(
                from: Calendar.current.dateComponents(
                    [.year],
                    from: .init()
                )
            ) else { return [] }
            let endOfYear = startOfYear.addingTimeInterval(Period.year.inSeconds)
            fetchRequest.predicate = NSPredicate(
                format: "date >= %@ && date <= %@",
                startOfYear as NSDate,
                endOfYear as NSDate
            )

            break
        }

        guard let entries = try? mainContextInstance.fetch(fetchRequest) else {
            return []
        }

        return entries.compactMap {
            guard
                let coffee = Coffee(rawValue: Int($0.coffee)),
                let milk = Milk(rawValue: Int($0.milk)),
                let size = Size(rawValue: Int($0.size)),
                let sugar = Sugar(rawValue: Int($0.sugar)),
                let date = $0.date
            else {
                return nil
            }
            return Consumable(
                coffee: coffee,
                milk: milk,
                size: size,
                sugar: sugar,
                date: date
            )
        }
    }

    func clear() throws {
        var throwingError: Error?

        let minionManagedObjectContextWorker: NSManagedObjectContext = NSManagedObjectContext(
            concurrencyType: .privateQueueConcurrencyType
        )
        minionManagedObjectContextWorker.parent = mainContextInstance
        minionManagedObjectContextWorker.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        minionManagedObjectContextWorker.performAndWait {
            let batchDeleteion = NSBatchDeleteRequest(fetchRequest: Consumption.fetchRequest())
            do {
                try minionManagedObjectContextWorker.execute(batchDeleteion)
            } catch {
                throwingError = error
            }
            PersistenceService.shared.saveWorkerContext(minionManagedObjectContextWorker)
            PersistenceService.shared.mergeWithMainContext()
        }

        if let error = throwingError {
            throw error
        }
    }
}
