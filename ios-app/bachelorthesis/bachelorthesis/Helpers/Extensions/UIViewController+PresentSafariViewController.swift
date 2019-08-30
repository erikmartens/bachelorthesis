//
//  UIViewController+PresentSafariViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
  
  func presentSafariViewController(for url: URL, withTint tintColor: UIColor?, completionHandler: (() -> Void)?) {
    let safariVC = SFSafariViewController(url: url)
    if let tintColor = tintColor {
      safariVC.preferredControlTintColor = tintColor
    }
    safariVC.modalPresentationStyle = .popover
    present(safariVC, animated: true, completion: completionHandler)
  }
}
