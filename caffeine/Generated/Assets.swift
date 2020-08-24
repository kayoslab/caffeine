// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let cupLarge = ImageAsset(name: "cupLarge")
  internal static let cupMiddle = ImageAsset(name: "cupMiddle")
  internal static let cupSmall = ImageAsset(name: "cupSmall")
  internal static let milkBottleCow = ImageAsset(name: "milkBottleCow")
  internal static let milkBottleLactoseFree = ImageAsset(name: "milkBottleLactoseFree")
  internal static let milkBottleSoy = ImageAsset(name: "milkBottleSoy")
  internal static let _1Shot = ImageAsset(name: "1-shot")
  internal static let _2Shots = ImageAsset(name: "2-shots")
  internal static let _3Shots = ImageAsset(name: "3-shots")
  internal static let _1Sugar = ImageAsset(name: "1-sugar")
  internal static let _2Sugars = ImageAsset(name: "2-sugars")
  internal static let _3Sugars = ImageAsset(name: "3-sugars")
  internal static let quickLarge = ImageAsset(name: "quickLarge")
  internal static let quickLargePressed = ImageAsset(name: "quickLargePressed")
  internal static let quickMedium = ImageAsset(name: "quickMedium")
  internal static let quickMediumPressed = ImageAsset(name: "quickMediumPressed")
  internal static let quickShot = ImageAsset(name: "quickShot")
  internal static let quickShotPressed = ImageAsset(name: "quickShotPressed")
  internal static let quickSmall = ImageAsset(name: "quickSmall")
  internal static let quickSmallPressed = ImageAsset(name: "quickSmallPressed")
  internal static let consumption = ImageAsset(name: "consumption")
  internal static let input = ImageAsset(name: "input")
  internal static let settings = ImageAsset(name: "settings")
  internal static let statistics = ImageAsset(name: "statistics")
  internal static let totalCupsIcon = ImageAsset(name: "totalCupsIcon")
  internal static let totalMilkIcon = ImageAsset(name: "totalMilkIcon")
  internal static let totalSugarIcon = ImageAsset(name: "totalSugarIcon")
  internal static let disclosure = ImageAsset(name: "disclosure")
  internal static let launchIcon = ImageAsset(name: "launchIcon")
  internal static let selectIconGreen = ImageAsset(name: "selectIcon-green")
  internal static let vektor = ImageAsset(name: "vektor")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
