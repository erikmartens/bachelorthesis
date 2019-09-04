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
  
  /// This `R.image` struct is generated, and contains static references to 1 images.
  struct image {
    /// Image `noimage`.
    static let noimage = Rswift.ImageResource(bundle: R.hostingBundle, name: "noimage")
    
    /// `UIImage(named: "noimage", bundle: ..., traitCollection: ...)`
    static func noimage(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.noimage, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `MainTableViewCell`.
    static let mainTableViewCell: Rswift.ReuseIdentifier<MainTableViewCell> = Rswift.ReuseIdentifier(identifier: "MainTableViewCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 4 storyboards.
  struct storyboard {
    /// Storyboard `Camera`.
    static let camera = _R.storyboard.camera()
    /// Storyboard `ImagePicker`.
    static let imagePicker = _R.storyboard.imagePicker()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "Camera", bundle: ...)`
    static func camera(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.camera)
    }
    
    /// `UIStoryboard(name: "ImagePicker", bundle: ...)`
    static func imagePicker(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.imagePicker)
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
  
  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
    struct launchScreen {
      fileprivate init() {}
    }
    
    /// This `R.string.localizable` struct is generated, and contains static references to 17 localization keys.
    struct localizable {
      /// en translation: Additional Information
      /// 
      /// Locales: en, de
      static let additional_information = Rswift.StringResource(key: "additional_information", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Camera
      /// 
      /// Locales: en, de
      static let picture_from_camera = Rswift.StringResource(key: "picture_from_camera", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Cancel
      /// 
      /// Locales: en, de
      static let cancel = Rswift.StringResource(key: "cancel", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Edges
      /// 
      /// Locales: en, de
      static let edges = Rswift.StringResource(key: "edges", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Gallery
      /// 
      /// Locales: en, de
      static let picture_from_gallery = Rswift.StringResource(key: "picture_from_gallery", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: GitHub
      /// 
      /// Locales: en, de
      static let github = Rswift.StringResource(key: "github", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Input Options Are Undefined
      /// 
      /// Locales: en, de
      static let input_options_undefined = Rswift.StringResource(key: "input_options_undefined", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Overlay
      /// 
      /// Locales: en, de
      static let overlay = Rswift.StringResource(key: "overlay", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Process Image
      /// 
      /// Locales: en, de
      static let process_image = Rswift.StringResource(key: "process_image", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Quadrangles
      /// 
      /// Locales: en, de
      static let quadrangles = Rswift.StringResource(key: "quadrangles", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Save Image
      /// 
      /// Locales: en, de
      static let save_image = Rswift.StringResource(key: "save_image", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Select Image
      /// 
      /// Locales: en, de
      static let select_image = Rswift.StringResource(key: "select_image", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Select Image Input Option
      /// 
      /// Locales: en, de
      static let select_input_option = Rswift.StringResource(key: "select_input_option", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Select a Library
      /// 
      /// Locales: en, de
      static let select_a_library = Rswift.StringResource(key: "select_a_library", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Select a framework
      /// 
      /// Locales: en, de
      static let select_a_framework = Rswift.StringResource(key: "select_a_framework", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: There are currently no input options specified. Please select a different framework.
      /// 
      /// Locales: en, de
      static let no_input_options = Rswift.StringResource(key: "no_input_options", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      /// en translation: Website
      /// 
      /// Locales: en, de
      static let website = Rswift.StringResource(key: "website", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "de"], comment: nil)
      
      /// en translation: Additional Information
      /// 
      /// Locales: en, de
      static func additional_information(_: Void = ()) -> String {
        return NSLocalizedString("additional_information", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Camera
      /// 
      /// Locales: en, de
      static func picture_from_camera(_: Void = ()) -> String {
        return NSLocalizedString("picture_from_camera", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Cancel
      /// 
      /// Locales: en, de
      static func cancel(_: Void = ()) -> String {
        return NSLocalizedString("cancel", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Edges
      /// 
      /// Locales: en, de
      static func edges(_: Void = ()) -> String {
        return NSLocalizedString("edges", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Gallery
      /// 
      /// Locales: en, de
      static func picture_from_gallery(_: Void = ()) -> String {
        return NSLocalizedString("picture_from_gallery", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: GitHub
      /// 
      /// Locales: en, de
      static func github(_: Void = ()) -> String {
        return NSLocalizedString("github", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Input Options Are Undefined
      /// 
      /// Locales: en, de
      static func input_options_undefined(_: Void = ()) -> String {
        return NSLocalizedString("input_options_undefined", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Overlay
      /// 
      /// Locales: en, de
      static func overlay(_: Void = ()) -> String {
        return NSLocalizedString("overlay", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Process Image
      /// 
      /// Locales: en, de
      static func process_image(_: Void = ()) -> String {
        return NSLocalizedString("process_image", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Quadrangles
      /// 
      /// Locales: en, de
      static func quadrangles(_: Void = ()) -> String {
        return NSLocalizedString("quadrangles", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Save Image
      /// 
      /// Locales: en, de
      static func save_image(_: Void = ()) -> String {
        return NSLocalizedString("save_image", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Select Image
      /// 
      /// Locales: en, de
      static func select_image(_: Void = ()) -> String {
        return NSLocalizedString("select_image", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Select Image Input Option
      /// 
      /// Locales: en, de
      static func select_input_option(_: Void = ()) -> String {
        return NSLocalizedString("select_input_option", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Select a Library
      /// 
      /// Locales: en, de
      static func select_a_library(_: Void = ()) -> String {
        return NSLocalizedString("select_a_library", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Select a framework
      /// 
      /// Locales: en, de
      static func select_a_framework(_: Void = ()) -> String {
        return NSLocalizedString("select_a_framework", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: There are currently no input options specified. Please select a different framework.
      /// 
      /// Locales: en, de
      static func no_input_options(_: Void = ()) -> String {
        return NSLocalizedString("no_input_options", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Website
      /// 
      /// Locales: en, de
      static func website(_: Void = ()) -> String {
        return NSLocalizedString("website", bundle: R.hostingBundle, comment: "")
      }
      
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
      try imagePicker.validate()
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
    
    struct imagePicker: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ImagePickerViewController
      
      let bundle = R.hostingBundle
      let name = "ImagePicker"
      
      static func validate() throws {
        if UIKit.UIImage(named: "noimage", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'noimage' is used in storyboard 'ImagePicker', but couldn't be loaded.") }
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
