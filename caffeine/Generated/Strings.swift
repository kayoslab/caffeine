// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// APR
  internal static let april = L10n.tr("Localizable", "April")
  /// AUG
  internal static let august = L10n.tr("Localizable", "August")
  /// No Milk
  internal static let black = L10n.tr("Localizable", "black")
  /// A nice hot cup of coffee
  internal static let consumptionTitle = L10n.tr("Localizable", "ConsumptionTitle")
  /// DEC
  internal static let december = L10n.tr("Localizable", "December")
  /// 2 Shots
  internal static let doubleshot = L10n.tr("Localizable", "doubleshot")
  /// FEB
  internal static let february = L10n.tr("Localizable", "February")
  /// FR
  internal static let friday = L10n.tr("Localizable", "Friday")
  /// Whole Milk
  internal static let fullfat = L10n.tr("Localizable", "fullfat")
  /// JAN
  internal static let january = L10n.tr("Localizable", "January")
  /// JULY
  internal static let july = L10n.tr("Localizable", "July")
  /// JUNE
  internal static let june = L10n.tr("Localizable", "June")
  /// Lactose Free
  internal static let lactosefree = L10n.tr("Localizable", "lactosefree")
  /// Large Cup
  internal static let large = L10n.tr("Localizable", "large")
  /// An Error occurd during Age loading. Please check your Health authorizations!
  internal static let loadAgeError = L10n.tr("Localizable", "LoadAgeError")
  /// MAR
  internal static let march = L10n.tr("Localizable", "March")
  /// MAY
  internal static let may = L10n.tr("Localizable", "May")
  /// Medium Cup
  internal static let medium = L10n.tr("Localizable", "medium")
  /// MO
  internal static let monday = L10n.tr("Localizable", "Monday")
  /// No Coffee
  internal static let noshot = L10n.tr("Localizable", "noshot")
  /// Espresso Cup
  internal static let nosize = L10n.tr("Localizable", "nosize")
  /// No Sugar
  internal static let nosugar = L10n.tr("Localizable", "nosugar")
  /// NOV
  internal static let november = L10n.tr("Localizable", "November")
  /// OCT
  internal static let october = L10n.tr("Localizable", "October")
  /// SA
  internal static let saturday = L10n.tr("Localizable", "Saturday")
  /// Please check your statistics and upate your personal data.
  internal static let sensibilityAlertBody = L10n.tr("Localizable", "SensibilityAlertBody")
  /// Sensibility Updated
  internal static let sensibilityAlertTitle = L10n.tr("Localizable", "SensibilityAlertTitle")
  /// SEPT
  internal static let september = L10n.tr("Localizable", "September")
  /// Coffee Saved!
  internal static let shortcutHeading = L10n.tr("Localizable", "ShortcutHeading")
  /// OK
  internal static let shortcutOK = L10n.tr("Localizable", "ShortcutOK")
  /// We updated your Statistics. Take a look.
  internal static let shortcutText = L10n.tr("Localizable", "ShortcutText")
  /// 1 Sugar
  internal static let singlepiece = L10n.tr("Localizable", "singlepiece")
  /// 1 Shot
  internal static let singleshot = L10n.tr("Localizable", "singleshot")
  /// Small Cup
  internal static let small = L10n.tr("Localizable", "small")
  /// Soy Milk
  internal static let soymilk = L10n.tr("Localizable", "soymilk")
  /// SU
  internal static let sunday = L10n.tr("Localizable", "Sunday")
  /// 3 Sugar
  internal static let threepiece = L10n.tr("Localizable", "threepiece")
  /// TH
  internal static let thursday = L10n.tr("Localizable", "Thursday")
  /// 3 Shots
  internal static let tripleshot = L10n.tr("Localizable", "tripleshot")
  /// TU
  internal static let tuesday = L10n.tr("Localizable", "Tuesday")
  /// 2 Sugar
  internal static let twopiece = L10n.tr("Localizable", "twopiece")
  /// WE
  internal static let wednesday = L10n.tr("Localizable", "Wednesday")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
