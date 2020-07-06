import Foundation
import HealthKit

class HealthStoreService {
    static var shared: HealthStoreService = .init()
    private let healthStore: HKHealthStore = .init()

    /// Readable data types from HealthKit
    private var readDataTypes: Set<HKObjectType> {
        if let caffeine = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine),
            let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth) {

            return .init([caffeine, dateOfBirth])
        } else {
            return .init()
        }
    }

    /// Writable data types from HealthKit
    private var writeDataTypes: Set<HKQuantityType> {
        if let caffeine = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) {
            return .init([caffeine])
        } else {
            return .init()
        }
    }

    private init() { }

    func requestPermission(completion: (() -> Void)? = nil) {
        // Request permissions for the HKHealthStore object
        HealthStoreService.shared.healthStore.requestAuthorization(
            toShare: writeDataTypes,
            read: readDataTypes
        ) { [weak self] (success, error) in
            guard success else {
                print("You didn't allow HealthKit to access these read/write data types.")
                print("In your app, try to handle this error gracefully when a user decides not to provide access.")
                print("The error was: \(error?.localizedDescription ?? "unknown"). If you're using a simulator, try it on a device.")
                return
            }

            self?.refreshAge()
            completion?()
        }
    }

    func refreshAge() {
        do {
            guard let birthday = try HealthStoreService.shared.healthStore
                .dateOfBirthComponents().date else {
                    return
            }
            let ageComponents = Calendar.current.dateComponents(
                [.year],
                from: birthday,
                to: .init()
            )
            guard let age = ageComponents.year else {
                return
            }

            UserSettings.userAge = age
        } catch {
            print(NSLocalizedString("LoadAgeError", comment: "Something went wrong!"))
        }
    }

    /*
    *
    * Get a Consumption Object and save its Data as Quantity Sample
    * into the Health Application.
    *
    */
    func storeConsumedObjectIntoHealth(_ consumption: ConsumableProperties) {

        let now: Date = Date()
        let metaData = [HKMetadataKeyFoodType: consumption.title]

        guard let hkcaffeine: HKQuantityType = .quantityType(
            forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine
        ) else {
            return
        }

        if healthStore.authorizationStatus(for: hkcaffeine) == HKAuthorizationStatus.sharingAuthorized
            && consumption.caffeine > 0.0 {

            let hkcaffeineQuantity: HKQuantity = .init(
                unit: .gramUnit(with: .milli),
                doubleValue: consumption.caffeine
            )
            let hkcaffeineSample: HKQuantitySample = .init(
                type: hkcaffeine,
                quantity: hkcaffeineQuantity,
                start: now,
                end: now,
                metadata: metaData
            )
            healthStore.save(
                hkcaffeineSample,
                withCompletion: { _, _ in }
            )
        }
    }

    internal func loadConsumedData(
        for period: Period,
        completion: @escaping (Bool, [HKSample]) -> Void
    ) {
        loadConsumedData(
            since: .init(timeIntervalSinceNow: -period.inSeconds),
            completion: completion
        )
    }

    private func loadConsumedData(
        since startDate: Date,
        until endDate: Date = .init(),
        completion: @escaping (Bool, [HKSample]) -> Void
    ) {
        guard let caffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine) else {
            return completion(false, [])
        }

        let timeSortDescriptor: NSSortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: HKQueryOptions()
        )

        let query = HKSampleQuery(
            sampleType: caffeineType,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [timeSortDescriptor],
            resultsHandler: { (_, result, error) in
                guard error == nil, let result = result else {
                    return completion(false, [])
                }

                completion(true, result)
            }
        )
        healthStore.execute(query)
    }
}
