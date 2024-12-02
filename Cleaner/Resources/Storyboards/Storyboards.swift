import UIKit

// MARK: - Storyboard Scenes

internal enum StoryboardScene {
  internal enum AllContacts: StoryboardType {
    internal static let storyboardName = "AllContacts"

    internal static let initialScene = InitialSceneType<AllContactsViewController>(storyboard: AllContacts.self)
  }
  internal enum Battery: StoryboardType {
    internal static let storyboardName = "Battery"

    internal static let initialScene = InitialSceneType<BatteryViewController>(storyboard: Battery.self)
  }
  internal enum Calendar: StoryboardType {
    internal static let storyboardName = "Calendar"

    internal static let initialScene = InitialSceneType<CalendarViewController>(storyboard: Calendar.self)
  }
  internal enum ContactsMenu: StoryboardType {
    internal static let storyboardName = "ContactsMenu"

    internal static let initialScene = InitialSceneType<ContactsMenuViewController>(storyboard: ContactsMenu.self)
  }
  internal enum DetailedPassword: StoryboardType {
    internal static let storyboardName = "DetailedPassword"

    internal static let initialScene = InitialSceneType<DetailedPasswordViewController>(storyboard: DetailedPassword.self)
  }
  internal enum DuplicateNameContacts: StoryboardType {
    internal static let storyboardName = "DuplicateNameContacts"

    internal static let initialScene = InitialSceneType<DuplicateNameContactsViewController>(storyboard: DuplicateNameContacts.self)
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
  internal enum Instructions: StoryboardType {
    internal static let storyboardName = "Instuctions"

    internal static let initialScene = InitialSceneType<InstructionsViewController>(storyboard: Instructions.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Main.self)
  }
  internal enum NoNameContacts: StoryboardType {
    internal static let storyboardName = "NoNameContacts"

    internal static let initialScene = InitialSceneType<NoNameContactsViewController>(storyboard: NoNameContacts.self)
  }
  internal enum NoNumberContacts: StoryboardType {
    internal static let storyboardName = "NoNumberContacts"

    internal static let initialScene = InitialSceneType<NoNumberContactsViewController>(storyboard: NoNumberContacts.self)
  }
  internal enum Passcode: StoryboardType {
    internal static let storyboardName = "Passcode"

    internal static let initialScene = InitialSceneType<PasscodeViewController>(storyboard: Passcode.self)
  }
  internal enum PasswordCreation: StoryboardType {
    internal static let storyboardName = "PasswordCreation"

    internal static let initialScene = InitialSceneType<PasswordCreationViewController>(storyboard: PasswordCreation.self)
  }
  internal enum PasswordList: StoryboardType {
    internal static let storyboardName = "PasswordList"

    internal static let initialScene = InitialSceneType<PasswordListViewController>(storyboard: PasswordList.self)
  }
  internal enum PhoneInfo: StoryboardType {
    internal static let storyboardName = "PhoneInfo"

    internal static let initialScene = InitialSceneType<PhoneInfoViewController>(storyboard: PhoneInfo.self)
  }
  internal enum RegularAssets: StoryboardType {
    internal static let storyboardName = "RegularAssets"

    internal static let initialScene = InitialSceneType<RegularAssetsViewController>(storyboard: RegularAssets.self)
  }
  internal enum SecretAlbum: StoryboardType {
    internal static let storyboardName = "SecretAlbum"

    internal static let initialScene = InitialSceneType<SecretAlbumViewController>(storyboard: SecretAlbum.self)
  }
  internal enum SecretContacts: StoryboardType {
    internal static let storyboardName = "SecretContacts"

    internal static let initialScene = InitialSceneType<SecretContactsViewController>(storyboard: SecretContacts.self)
  }
  internal enum Settings: StoryboardType {
    internal static let storyboardName = "Settings"

    internal static let initialScene = InitialSceneType<SettingsViewController>(storyboard: Settings.self)
  }
}

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

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
