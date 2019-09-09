//
//  AvailableScanners.swift
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import Foundation

enum ScannerLibrary {
  case weScan
  case gpuImage
  case openCV
}

enum ImageInputOption {
  case camera
  case gallery
  
  var title: String {
    switch self {
    case .camera: return R.string.localizable.picture_from_camera()
    case .gallery: return R.string.localizable.picture_from_gallery()
    }
  }
}

struct ScannerDTO {
  let title: String
  let website: URL?
  let github: URL?
  let scannerLibrary: ScannerLibrary
  let inputOptions: [ImageInputOption]
}

let availableScanners = [
  ScannerDTO(title: "GPUImage",
             website: URL(string: "http://www.sunsetlakesoftware.com/"),
             github: URL(string: "https://github.com/BradLarson/GPUImage"),
             scannerLibrary: .gpuImage,
             inputOptions: []),
  ScannerDTO(title: "OpenCV",
             website: URL(string: "https://opencv.org/"),
             github: URL(string: "https://github.com/opencv"),
             scannerLibrary: .openCV,
             inputOptions: [.camera, .gallery]),
  ScannerDTO(title: "WeScan",
             website: URL(string: "https://wetransfer.com/"),
             github: URL(string: "https://github.com/WeTransfer/WeScan"),
             scannerLibrary: .weScan,
             inputOptions: [.camera, .gallery])
]
