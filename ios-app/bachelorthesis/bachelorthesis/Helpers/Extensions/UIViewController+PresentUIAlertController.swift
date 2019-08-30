//
//  UIViewController+PresentUIAlertController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func presentAlertViewController(withTitle title: String?, message: String?, actions: [String: ((UIAlertAction) -> Void)], addDefaultCancelAction: Bool) {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    
    actions.keys.forEach { key in
      let action = UIAlertAction(title: key,
                                 style: .default,
                                 handler: actions[key])
      alertController.addAction(action)
    }
    
    if addDefaultCancelAction {
      let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .default) { _ in
        // nothing to do here, closes itself
      }
      alertController.addAction(cancelAction)
    }
    
    alertController.view.tintColor = .blue
    present(alertController, animated: true)
  }
}
