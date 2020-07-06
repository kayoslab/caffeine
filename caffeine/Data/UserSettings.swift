import Foundation

let defaults = UserDefaults(suiteName: "caffeine")

@propertyWrapper
struct UserDefault<T> {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            return defaults?.object(forKey: key) as? T
        }
        set {
            defaults?.set(newValue, forKey: key)
        }
    }
}

/// The Settings object can be used to easily access the standard
/// UserDefaults. This way we can ensure that identifier are stored
/// in a centralised way.
struct UserSettings {

    // swiftlint:disable let_var_whitespace
    @UserDefault("caffeine.age")
    private static var age: Int?

    @UserDefault("caffeine.weight")
    private static var weight: Int?

    @UserDefault("caffeine.height")
    private static var height: Int?

    @UserDefault("caffeine.sensibility")
    private static var sensibility: Int?

    @UserDefault("caffeine.sex")
    private static var sex: Int?

    @UserDefault("caffeine.sex")
    private static var steroids: Bool?
    // swiftlint:enable let_var_whitespace

    static var userAge: Int {
        get {
            guard let age = UserSettings.age else {
                UserSettings.age = 18
                return 18
            }
            return age
        }
        set {
            UserSettings.age = newValue
        }
    }

    static var userWeight: Int {
        get {
            guard let weight = UserSettings.weight else {
                UserSettings.weight = 100
                return 100
            }
            return weight
        }
        set {
            UserSettings.weight = newValue
        }
    }

    static var userHeight: Int {
        get {
            guard let height = UserSettings.height else {
                UserSettings.height = 100
                return 100
            }
            return height
        }
        set {
            UserSettings.height = newValue
        }
    }

    static var userSensibility: Int {
        get {
            guard let sensibility = UserSettings.sensibility else {
                UserSettings.sensibility = 50
                return 50
            }
            return sensibility
        }
        set {
            UserSettings.sensibility = newValue
        }
    }

    static var userSex: Int {
        get {
            guard let sex = UserSettings.sex else {
                UserSettings.sex = 50
                return 50
            }
            return sex
        }
        set {
            UserSettings.sex = newValue
        }
    }

    static var userSteroids: Bool {
        get {
            guard let steroids = UserSettings.steroids else {
                UserSettings.steroids = false
                return false
            }
            return steroids
        }
        set {
            UserSettings.steroids = newValue
        }
    }

    static var userBmi: Double {
        return Double(userWeight) / pow(Double(userHeight), 2)
    }
}
