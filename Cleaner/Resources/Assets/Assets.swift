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
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let abtut1 = ImageAsset(name: "abtut1")
  internal static let abtut2 = ImageAsset(name: "abtut2")
  internal static let abtut3 = ImageAsset(name: "abtut3")
  internal static let abtut4 = ImageAsset(name: "abtut4")
  internal static let abtut5 = ImageAsset(name: "abtut5")
  internal static let fi6490402 = ImageAsset(name: "fi_6490402")
  internal static let closeButton = ImageAsset(name: "Close Button")
  internal static let emptyCheckBox = ImageAsset(name: "EmptyCheckBox")
  internal static let selectedCheckBox = ImageAsset(name: "SelectedCheckBox")
  internal static let arrowBackBlue = ImageAsset(name: "arrowBackBlue")
  internal static let arrowForwardBlack = ImageAsset(name: "arrowForwardBlack")
  internal static let gradientButton = ImageAsset(name: "gradientButton")
  internal static let notActiveButtonBG = ImageAsset(name: "notActiveButtonBG")
  internal static let checkBox = ImageAsset(name: "Check box")
  internal static let frame451711 = ImageAsset(name: "Frame 451711")
  internal static let frame451712 = ImageAsset(name: "Frame 451712")
  internal static let group452254 = ImageAsset(name: "Group 452254")
  internal static let group = ImageAsset(name: "Group")
  internal static let ca1 = ImageAsset(name: "ca1")
  internal static let ca10 = ImageAsset(name: "ca10")
  internal static let ca11 = ImageAsset(name: "ca11")
  internal static let ca12 = ImageAsset(name: "ca12")
  internal static let ca13 = ImageAsset(name: "ca13")
  internal static let ca2 = ImageAsset(name: "ca2")
  internal static let ca3 = ImageAsset(name: "ca3")
  internal static let ca4 = ImageAsset(name: "ca4")
  internal static let ca5 = ImageAsset(name: "ca5")
  internal static let ca6 = ImageAsset(name: "ca6")
  internal static let ca7 = ImageAsset(name: "ca7")
  internal static let ca8 = ImageAsset(name: "ca8")
  internal static let ca9 = ImageAsset(name: "ca9")
  internal static let vector = ImageAsset(name: "Vector")
  internal static let fi1011411 = ImageAsset(name: "fi_1011411")
  internal static let fi159599 = ImageAsset(name: "fi_159599")
  internal static let fi1827425 = ImageAsset(name: "fi_1827425")
  internal static let fi3103384 = ImageAsset(name: "fi_3103384")
  internal static let fi3856888 = ImageAsset(name: "fi_3856888")
  internal static let fi4391389 = ImageAsset(name: "fi_4391389")
  internal static let fi4666810 = ImageAsset(name: "fi_4666810")
  internal static let fi471662 = ImageAsset(name: "fi_471662")
  internal static let fi7171736 = ImageAsset(name: "fi_7171736")
  internal static let fi8765292 = ImageAsset(name: "fi_8765292")
  internal static let image16 = ImageAsset(name: "image 16")
  internal static let image18 = ImageAsset(name: "image 18")
  internal static let image19 = ImageAsset(name: "image 19")
  internal static let image20 = ImageAsset(name: "image 20")
  internal static let image21 = ImageAsset(name: "image 21")
  internal static let image22 = ImageAsset(name: "image 22")
  internal static let image23 = ImageAsset(name: "image 23")
  internal static let image24 = ImageAsset(name: "image 24")
  internal static let image25 = ImageAsset(name: "image 25")
  internal static let image27 = ImageAsset(name: "image 27")
  internal static let image28 = ImageAsset(name: "image 28")
  internal static let image31 = ImageAsset(name: "image 31")
  internal static let image32 = ImageAsset(name: "image 32")
  internal static let black = ColorAsset(name: "Black")
  internal static let blue = ColorAsset(name: "Blue")
  internal static let cards = ColorAsset(name: "Cards")
  internal static let grey = ColorAsset(name: "Grey")
  internal static let red = ColorAsset(name: "Red")
  internal static let white = ColorAsset(name: "White")
  internal static let greyBackgroundColor = ColorAsset(name: "GreyBackground") //used
  internal static let download = ImageAsset(name: "download")
  internal static let upload = ImageAsset(name: "upload")
  internal static let wifiConnection = ImageAsset(name: "wifiConnection")
  internal static let arrowForwardWhite = ImageAsset(name: "arrowForwardWhite")
  internal static let mainAdBlock = ImageAsset(name: "mainAdBlock")
  internal static let mainBattery = ImageAsset(name: "mainBattery")
  internal static let mainCPU = ImageAsset(name: "mainCPU")
  internal static let mainCalendar = ImageAsset(name: "mainCalendar")
  internal static let mainConnection = ImageAsset(name: "mainConnection")
  internal static let mainContacts = ImageAsset(name: "mainContacts")
  internal static let mainDownload = ImageAsset(name: "mainDownload")
  internal static let mainPasswords = ImageAsset(name: "mainPasswords")
  internal static let mainPhoto = ImageAsset(name: "mainPhoto")
  internal static let mainRAM = ImageAsset(name: "mainRAM")
  internal static let mainSafari = ImageAsset(name: "mainSafari")
  internal static let mainSecret = ImageAsset(name: "mainSecret")
  internal static let mainSettings = ImageAsset(name: "mainSettings")
  internal static let mainTelegram = ImageAsset(name: "mainTelegram")
  internal static let mainViber = ImageAsset(name: "mainViber")
  internal static let mainWidgets = ImageAsset(name: "mainWidgets")
  internal static let memoryUsed = ImageAsset(name: "memoryUsed")
  internal static let dupPhotosMenu = ImageAsset(name: "dupPhotosMenu")
  internal static let photosTextMenu = ImageAsset(name: "photosTextMenu")
  internal static let purpleCheckmark = ImageAsset(name: "purpleCheckmark")
  internal static let screenshotsMenu = ImageAsset(name: "screenshotsMenu")
  internal static let similarPhotosMenu = ImageAsset(name: "similarPhotosMenu")
  internal static let similarVideoMenu = ImageAsset(name: "similarVideoMenu")
  internal static let videoCompMenu = ImageAsset(name: "videoCompMenu")
  internal static let copy = ImageAsset(name: "copy")
  internal static let delete = ImageAsset(name: "delete")
  internal static let magnifier = ImageAsset(name: "magnifier")
  internal static let openLink = ImageAsset(name: "openLink")
  internal static let plus = ImageAsset(name: "plus")
  internal static let sharePass = ImageAsset(name: "sharePass")
  internal static let greenFolder = ImageAsset(name: "greenFolder")
  internal static let paywallBG = ImageAsset(name: "paywallBG")
  internal static let paywallCross = ImageAsset(name: "paywallCross")
  internal static let smartClean = ImageAsset(name: "smartClean")
  internal static let infoCPU = ImageAsset(name: "infoCPU")
  internal static let infoRAM = ImageAsset(name: "infoRAM")
  internal static let infoSpeed = ImageAsset(name: "infoSpeed")
  internal static let basilViberSolid = ImageAsset(name: "Basil Viber Solid")
  internal static let mingcuteSafariFill = ImageAsset(name: "Mingcute Safari Fill")
  internal static let setting2 = ImageAsset(name: "Setting 2")
  internal static let telegramLogos = ImageAsset(name: "Telegram logos")
  internal static let whatsAppFill = ImageAsset(name: "WhatsApp Fill")
  internal static let lock = ImageAsset(name: "lock")
  internal static let crown = ImageAsset(name: "crown")
  internal static let rateApp = ImageAsset(name: "rateApp")
  internal static let shareApp = ImageAsset(name: "shareApp")
  internal static let bigDuplicateContacts = ImageAsset(name: "bigDuplicateContacts")
  internal static let bigIncompleteContacts = ImageAsset(name: "bigIncompleteContacts")
  internal static let duplicateContacts = ImageAsset(name: "duplicateContacts")
  internal static let incompleteContacts = ImageAsset(name: "incompleteContacts")
  internal static let splash = ImageAsset(name: "splash")
  internal static let splashBG = ImageAsset(name: "splashBG")
  internal static let device1whats = ImageAsset(name: "Device 1whats")
  internal static let device11whats = ImageAsset(name: "Device-11whats")
  internal static let device4whats = ImageAsset(name: "Device-4whats")
  internal static let device5whats = ImageAsset(name: "Device-5whats")
  internal static let device6whats = ImageAsset(name: "Device-6whats")
  internal static let device7whats = ImageAsset(name: "Device-7whats")
  internal static let device27clean = ImageAsset(name: "Device-27clean")
  internal static let device28clean = ImageAsset(name: "Device-28clean")
  internal static let device29clean = ImageAsset(name: "Device-29clean")
  internal static let deviceclean = ImageAsset(name: "Deviceclean")
  internal static let device1tel = ImageAsset(name: "Device-1tel")
  internal static let device3tel = ImageAsset(name: "Device-3tel")
  internal static let device4tel = ImageAsset(name: "Device-4tel")
  internal static let devicetel1 = ImageAsset(name: "Devicetel-1")
  internal static let devicetel = ImageAsset(name: "Devicetel")
  internal static let device13off = ImageAsset(name: "Device-13off")
  internal static let device14off = ImageAsset(name: "Device-14off")
  internal static let device2off = ImageAsset(name: "Device-2off")
  internal static let deviceoff = ImageAsset(name: "Deviceoff")
  internal static let device1 = ImageAsset(name: "Device-1")
  internal static let device11 = ImageAsset(name: "Device-11")
  internal static let device12 = ImageAsset(name: "Device-12")
  internal static let device3 = ImageAsset(name: "Device-3")
  internal static let device9 = ImageAsset(name: "Device-9")
  internal static let device = ImageAsset(name: "Device")
  internal static let device11optimize = ImageAsset(name: "Device-11optimize")
  internal static let device12optimize = ImageAsset(name: "Device-12optimize")
  internal static let device3optimize = ImageAsset(name: "Device-3optimize")
  internal static let device9optimize = ImageAsset(name: "Device-9optimize")
  internal static let deviceoptimize1 = ImageAsset(name: "Deviceoptimize-1")
  internal static let deviceoptimize = ImageAsset(name: "Deviceoptimize")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
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
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
