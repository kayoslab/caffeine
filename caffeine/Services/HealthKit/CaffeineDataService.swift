import Foundation
import HealthKit

class CaffeineDataService {
    static var shared: CaffeineDataService = .init()

    // Value for Gender Manipulation [3000 .. 3600]
    // Women have an up to 1h longer half-life time of caffeine in blood (3000sec. + 600sec)
    private let genderModifier: Double = 3000.0
    private let sensibilityGenderModifier: Double = 600.0
    // Value for Contraceptive Steroids Manipulation [5800 .. 7200]
    private let steroidsModifier: Double = 5800.0
    private let sensibilitySteroidsModifier: Double = 1400.0
    // SafeLimits
    private let safeLimitAdult = 350.0
    private let safeLimitModifierAdult = 100.0

    private init() { }

    /*
    *
    * Uses Age and Weight to calculate the Healthy Ammount of Caffeine
    * Returns the Caffeine Value in the Completion Block
    * Does not include Body Data yet.
    *
    */
    func healthyAmount() -> Double? {
        HealthStoreService.shared.refreshAge()

        let expectedSensibility = Double(UserSettings.userSensibility) / 100.0
        var safeLimit = 0.0
        var calculationAge: Int {
            if UserSettings.userAge >= 0 {
                return UserSettings.userAge
            } else {
                return 18
            }
        }

        if calculationAge <= 18 {
            safeLimit = (pow(M_E, 0.3222 * Double(calculationAge)) + 21.6243)
            safeLimit += (1.0 - expectedSensibility) * (pow(M_E, 0.2521 * Double(calculationAge)) + 9.3297)
        } else {
            safeLimit = safeLimitAdult + safeLimitModifierAdult * (1.0 - expectedSensibility)
        }

        return safeLimit
    }

    func getCaffeineConsumption(
        in period: Period = .day,
        completion: @escaping (Bool, Double?) -> Void
    ) {
        var caffeine: Double = 0.0
        HealthStoreService.shared.loadConsumedData(for: period) { (success, data) in
            guard success else {
                return completion(false, nil)
            }

            let caffeineUnit: HKUnit = .gramUnit(with: .milli)

            for quantitySample in data {
                guard
                    let quantity: HKQuantity = (quantitySample as? HKQuantitySample)?.quantity
                else {
                    continue
                }
                caffeine += quantity.doubleValue(for: caffeineUnit)
            }
            completion(true, caffeine)
        }
    }

    /*
    *
    * The Half Life of Caffeine in healthy adults is about 5.7 hours
    * Source[1]: http://www.ncbi.nlm.nih.gov/pubmed/7361718?dopt=Abstract
    * See default Value
    *
    * "However, at higher doses (e.g. 250–500mg single dose), the clearance of caffeine is
    * significantly reduced and its elimination half-life is prolonged, indicating non-linearity"
    * Source[2]: http://www.militaryenergygum.com/wp-content/uploads/Multiple-Dose-Pharmacokinetics.pdf
    * See Switch-Case
    *
    * "The t1/2 (beta) was significantly prolonged in women on OCS (10.7 +/- 3.0 hr vs. 6.2 +/- 1.6)"
    * Source[3]: http://www.ncbi.nlm.nih.gov/pubmed/7359014
    * See contraceptiveSteroidsTimeModifier
    *
    * Concentration is unrelated to weight and healthy situation
    *
    * This is where most of the Magic happens. Sparkle!
    *
    */
    func getCaffeineConcentration(
        _ completion: @escaping (Bool, Double?) -> Void
    ) {
        // TODO: Migrate to coredata based information
        HealthStoreService.shared.loadConsumedData(for: .day) { [weak self] (success, data) in
            guard success else {
                return completion(false, nil)
            }

            guard
                let genderModifier = self?.genderModifier,
                let sensibilityGenderModifier = self?.sensibilityGenderModifier,
                let steroidsModifier = self?.steroidsModifier,
                let sensibilitySteroidsModifier = self?.sensibilitySteroidsModifier
            else {
                return
            }

            var caffeine: Double = 0.0
            let caffeineUnit: HKUnit = HKUnit.gramUnit(with: .milli)

            for quantitySample: HKSample in data {
                let quantity: HKQuantity = (quantitySample as! HKQuantitySample).quantity
                let caffeineInQuantity: Double = quantity.doubleValue(for: caffeineUnit)
                var halfLifeSeconds: Double = 0.0

                // Linear Interpolation of non Linear Values from [2]
                // and average divergence for simplification by Sensibility from [2]
                halfLifeSeconds = (0.0224 * caffeineInQuantity + 4.4) * 3600
                let isSensible: Bool = UserSettings.userSensibility > 50 ? true : false
                var sensibility: Double = 0.0
                var sensibilityByValue: Double = 0.0

                if (isSensible) {
                    sensibility = (Double(UserSettings.userSensibility) - 50.0) / 100.0
                    sensibilityByValue = (0.0019 * caffeineInQuantity + 2.63) *
                        (1.0 - sensibility)
                } else {
                    sensibility = Double(UserSettings.userSensibility) / 100.0
                    sensibilityByValue = (-0.0019 * caffeineInQuantity - 2.63) *
                        (1.0 - sensibility)
                }

                halfLifeSeconds = halfLifeSeconds + sensibilityByValue
                sensibility = Double(UserSettings.userSensibility) / 100.0

                let expectedGenderValue: Double = Double(UserSettings.userSex) / 100.0
                let genderTimeModifier: Double = genderModifier +
                    (sensibilityGenderModifier * (1.0 - sensibility))
                let genderModifier: Double = genderTimeModifier *
                    expectedGenderValue
                halfLifeSeconds += genderModifier

                let contraceptiveSteroids: Bool = UserSettings.userSteroids
                let contraceptiveSteroidsTimeModifier: Double = steroidsModifier + (sensibilitySteroidsModifier *
                    (1.0 - sensibility))
                if contraceptiveSteroids {
                    halfLifeSeconds += contraceptiveSteroidsTimeModifier
                }

                let elapsedTime = Date().timeIntervalSince(quantitySample.startDate)
                let caffeineConcentrationOfSample = quantity.doubleValue(for: caffeineUnit) *
                    pow(0.5, (elapsedTime / halfLifeSeconds))
                caffeine = caffeine + caffeineConcentrationOfSample
            }

            completion(true, caffeine)
        }
    }

}

extension CaffeineDataService {

    /// Data for a longer period (e.g. week, month, year) is historically passed as an array of arrays.
    /// This function is a wrapper for `calculateCaffeineData` which maps the data onto
    /// An array of double.
    private func calculateCaffeinePeriodData(_ data: [[HKSample]?]) -> [Double] {
        return data.map {
            guard let data = $0 else { return 0.0 }
            return CaffeineDataService.calculateCaffeineData(data)
        }
    }

    private static func calculateCaffeineData(_ data: [HKSample]) -> Double {
        return data
            .compactMap({
                ($0 as? HKQuantitySample)?
                        .quantity
                        .doubleValue(for: .gramUnit(with: .milli))
                }
        ).reduce(0.0, +)
    }
}
