//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `MainTableViewCell`.
    static let mainTableViewCell: Rswift.ReuseIdentifier<MainTableViewCell> = Rswift.ReuseIdentifier(identifier: "MainTableViewCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 3 storyboards.
  struct storyboard {
    /// Storyboard `Camera`.
    static let camera = _R.storyboard.camera()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "Camera", bundle: ...)`
    static func camera(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.camera)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 3 localization tables.
  struct string {
    /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
    struct launchScreen {
      fileprivate init() {}
    }
    
    /// This `R.string.localizable` struct is generated, and contains static references to 4 localization keys.
    struct localizable {
      /// en translation: Cancel
      /// 
      /// Locales: en, de
      static let cancel = Rswift.StringResource(key: "cancel", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: GitHub
      /// 
      /// Locales: en, de
      static let github = Rswift.StringResource(key: "github", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Select a Library
      /// 
      /// Locales: en, de
      static let select_a_library = Rswift.StringResource(key: "select_a_library", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Website
      /// 
      /// Locales: en, de
      static let website = Rswift.StringResource(key: "website", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      
      /// en translation: Cancel
      /// 
      /// Locales: en, de
      static func cancel(_: Void = ()) -> String {
        return NSLocalizedString("cancel", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: GitHub
      /// 
      /// Locales: en, de
      static func github(_: Void = ()) -> String {
        return NSLocalizedString("github", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Select a Library
      /// 
      /// Locales: en, de
      static func select_a_library(_: Void = ()) -> String {
        return NSLocalizedString("select_a_library", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Website
      /// 
      /// Locales: en, de
      static func website(_: Void = ()) -> String {
        return NSLocalizedString("website", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    /// This `R.string.main` struct is generated, and contains static references to 0 localization keys.
    struct main {
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try camera.validate()
      try launchScreen.validate()
      try main.validate()
    }
    
    struct camera: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = CameraViewController
      
      let bundle = R.hostingBundle
      let name = "Camera"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
