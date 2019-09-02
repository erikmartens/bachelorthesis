//
// UIDeviceOrientation->AVCaptureVideoOrientation.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 02.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit

extension AVCaptureVideoOrientation {
  init?(from deviceInterfaceOrientation: UIDeviceOrientation) {
        switch UIDevice.current.orientation {
        case .unknown, .faceUp, .faceDown:
          return nil
        case .portrait:
          self = .portrait
        case .portraitUpsideDown:
          self = .portraitUpsideDown
        case .landscapeLeft:
          self = .landscapeLeft
        case .landscapeRight:
          self = .landscapeRight
        @unknown default:
            return nil
    }
  }
}
