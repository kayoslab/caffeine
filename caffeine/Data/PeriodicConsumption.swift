import Foundation

enum Period {
    case day
    case week
    case month
    case year

    init(with selectorState: SelectorState) {
        switch selectorState {
        case .day:
            self = .day
        case .week:
            self = .week
        case .month:
            self = .month
        case .year:
            self = .year
        }
    }

    var iterations: Int {
        switch self {
        case .day:
            return 24
        case .week:
            return 7
        case .month:
            return 31
        case .year:
            return 365
        }
    }

    var inSeconds: Double {
        let minute = 60.0
        let hour = minute * 60.0

        switch self {
        case .day:
            return hour * Double(self.iterations)
        case .week:
            return Period.day.inSeconds * Double(self.iterations)
        case .month:
            return Period.day.inSeconds * Double(self.iterations)
        case .year:
            return Period.day.inSeconds * Double(self.iterations)
        }
    }
}

struct PeriodicConsumption {
    let period: Period

    private let rawData: [Consumable]

    private var rawDataProperties: [ConsumableProperties] {
        return rawData.map { ConsumableProperties($0) }
    }

    var periodicData: [[Consumable]] {
        var periodicData: [[Consumable]] = .init(repeating: [], count: period.iterations)

        switch period {
        case .day:
            rawData.forEach {
                let hour = Calendar.current.component(.hour, from: $0.date)
                periodicData[hour].append($0)
            }
        case .week:
            rawData.forEach {
                let weekday = Calendar.current.component(.weekday, from: $0.date)
                periodicData[weekday - 1].append($0)
            }
        case .month:
            rawData.forEach {
                let day = Calendar.current.ordinality(of: .day, in: .month, for: $0.date) ?? 0
                periodicData[day - 1].append($0)
            }
        case .year:
            rawData.forEach {
                let month = Calendar.current.ordinality(of: .day, in: .year, for: $0.date) ?? 0
                periodicData[month - 1].append($0)
            }
        }

        return periodicData
    }

    var shots: Int {
        return rawData.reduce(0, { $0 + $1.coffee.rawValue })
    }

    var caffeine: Double {
        return rawDataProperties.reduce(0.0, { $0 + Double($1.caffeine) })
    }

    var milk: Double {
        return rawDataProperties.reduce(0.0, { $0 + Double($1.amountOfMilk) })
    }

    var sugar: Double {
        rawDataProperties.reduce(0.0, { $0 + Double($1.sugar) })
    }

    init(_ period: Period, _ consumables: [Consumable]) {
        self.period = period
        self.rawData = consumables
    }
}
