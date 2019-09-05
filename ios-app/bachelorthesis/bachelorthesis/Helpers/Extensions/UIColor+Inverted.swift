//
//  UIColor+Inverted.swift
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 04.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit

extension UIColor {
  var inverted: UIColor {
    var alpha: CGFloat = 1.0
    
    var white: CGFloat = 0.0
    if getWhite(&white, alpha: &alpha) {
      return UIColor(white: 1.0 - white, alpha: alpha)
    }
    
    var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
    if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
    }
    
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
    if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
    }
    
    return self
  }
}
