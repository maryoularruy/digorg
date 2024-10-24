// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length prefer_self_in_static_references
// swiftlint:disable type_body_length type_name
internal enum StoryboardScene {
  internal enum AdBlocker: StoryboardType {
    internal static let storyboardName = "AdBlocker"

    internal static let initialScene = InitialSceneType<AdBlockerViewController>(storyboard: AdBlocker.self)
  }
  internal enum CalendarList: StoryboardType {
    internal static let storyboardName = "CalendarList"

    internal static let initialScene = InitialSceneType<CalendarListViewController>(storyboard: CalendarList.self)
  }
  internal enum Connection: StoryboardType {
    internal static let storyboardName = "Connection"

    internal static let initialScene = InitialSceneType<ConnectionViewController>(storyboard: Connection.self)
  }
  internal enum ContactsMenu: StoryboardType {
    internal static let storyboardName = "ContactsMenu"

    internal static let initialScene = InitialSceneType<ContactsMenuViewController>(storyboard: ContactsMenu.self)
  }
  internal enum DetailedPassword: StoryboardType {
    internal static let storyboardName = "DetailedPassword"

    internal static let initialScene = InitialSceneType<DetailedPasswordViewController>(storyboard: DetailedPassword.self)
  }
  internal enum DuplicateContacts: StoryboardType {
    internal static let storyboardName = "DuplicateContacts"

    internal static let initialScene = InitialSceneType<DuplicateContactsViewController>(storyboard: DuplicateContacts.self)
  }
  internal enum EditPassword: StoryboardType {
    internal static let storyboardName = "EditPassword"

    internal static let initialScene = InitialSceneType<EditPasswordViewController>(storyboard: EditPassword.self)
  }
  internal enum GroupedAssets: StoryboardType {
    internal static let storyboardName = "GroupedAssets"

    internal static let initialScene = InitialSceneType<GroupedAssetsViewController>(storyboard: GroupedAssets.self)
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Main.self)
  }
  internal enum MainBattery: StoryboardType {
    internal static let storyboardName = "MainBattery"

    internal static let initialScene = InitialSceneType<MainBatteryViewController>(storyboard: MainBattery.self)
  }
  internal enum NoNameContacts: StoryboardType {
    internal static let storyboardName = "NoNameContacts"

    internal static let initialScene = InitialSceneType<NoNameContactsViewController>(storyboard: NoNameContacts.self)
  }
  internal enum PasswordCreation: StoryboardType {
    internal static let storyboardName = "PasswordCreation"

    internal static let initialScene = InitialSceneType<PasswordCreationViewController>(storyboard: PasswordCreation.self)
  }
  internal enum PasswordList: StoryboardType {
    internal static let storyboardName = "PasswordList"

    internal static let initialScene = InitialSceneType<PasswordListViewController>(storyboard: PasswordList.self)
  }
  internal enum Paywall: StoryboardType {
    internal static let storyboardName = "Paywall"

    internal static let initialScene = InitialSceneType<PaywallViewController>(storyboard: Paywall.self)
  }
  internal enum PhoneInfo: StoryboardType {
    internal static let storyboardName = "PhoneInfo"

    internal static let initialScene = InitialSceneType<PhoneInfoViewController>(storyboard: PhoneInfo.self)
  }
  internal enum PhotoVideoMenu: StoryboardType {
    internal static let storyboardName = "PhotoVideoMenu"

    internal static let initialScene = InitialSceneType<PhotoVideoMenuViewController>(storyboard: PhotoVideoMenu.self)
  }
  internal enum PrivateMenu: StoryboardType {
    internal static let storyboardName = "PrivateMenu"

    internal static let initialScene = InitialSceneType<PrivateMenuViewController>(storyboard: PrivateMenu.self)
  }
  internal enum RegularAssets: StoryboardType {
    internal static let storyboardName = "RegularAssets"

    internal static let initialScene = InitialSceneType<RegularAssetsViewController>(storyboard: RegularAssets.self)
  }
  internal enum Search: StoryboardType {
    internal static let storyboardName = "Search"

    internal static let initialScene = InitialSceneType<SearchViewController>(storyboard: Search.self)
  }
  internal enum Settings: StoryboardType {
    internal static let storyboardName = "Settings"

    internal static let initialScene = InitialSceneType<SettingsViewController>(storyboard: Settings.self)
  }
  internal enum Stories: StoryboardType {
    internal static let storyboardName = "Stories"

    internal static let initialScene = InitialSceneType<StoriesViewController>(storyboard: Stories.self)
  }
  internal enum Tutorial: StoryboardType {
    internal static let storyboardName = "Tutorial"

    internal static let initialScene = InitialSceneType<TutorialViewController>(storyboard: Tutorial.self)
  }
  internal enum Tutorials: StoryboardType {
    internal static let storyboardName = "Tutorials"

    internal static let automaticUpdates = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "AutomaticUpdates")

    internal static let batteryUsage = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "BatteryUsage")

    internal static let brightness = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "Brightness")

    internal static let cellularCommunication = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "CellularCommunication")

    internal static let geolocationServices = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "GeolocationServices")

    internal static let notifications = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "Notifications")

    internal static let powerSaving = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "PowerSaving")

    internal static let wiFiUpdate = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "WiFiUpdate")

    internal static let iPhoneCooling = SceneType<PowerSavingModeViewController>(storyboard: Tutorials.self, identifier: "iPhoneCooling")
  }
  internal enum WiFiProtection: StoryboardType {
    internal static let storyboardName = "WiFiProtection"

    internal static let initialScene = InitialSceneType<WiFiProtectionViewController>(storyboard: WiFiProtection.self)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length prefer_self_in_static_references
// swiftlint:enable type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
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
