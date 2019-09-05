//
//  FramedButton.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 01.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit

@IBDesignable class FramedButton: UIButton {
  
  // MARK: - Properties
  
  @IBInspectable var cornerRadius: CGFloat = 5.0 {
    didSet {
      layer.cornerRadius = cornerRadius
      setNeedsDisplay()
    }
  }
  
  @IBInspectable var borderWidth: CGFloat = 1.0 {
    didSet {
      layer.borderWidth = borderWidth
      setNeedsDisplay()
    }
  }
  
  @IBInspectable var accentColor: UIColor = .clear {
    didSet {
      layer.borderColor = accentColor.cgColor
      highLightBackgroundColor = accentColor
      titleLabel?.textColor = accentColor
      setNeedsDisplay()
    }
  }
  
  // MARK: - Private Properties
  
  private let spacing: CGFloat = 8.0
  private var highLightBackgroundColor: UIColor = .clear
  
  // MARK: - Initialization
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = accentColor.cgColor
    highLightBackgroundColor = accentColor
    titleLabel?.textColor = accentColor
    contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
    
    layer.cornerRadius = frame.height/2
  }
  
  // MARK: - Override Functions
  
  override open var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        titleLabel?.textColor = highLightBackgroundColor.inverted
        layer.backgroundColor = highLightBackgroundColor.cgColor
        return
      }
      titleLabel?.textColor = accentColor
      layer.backgroundColor = UIColor.clear.cgColor
    }
  }
}
