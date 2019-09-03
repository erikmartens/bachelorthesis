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

struct ScannerDTO {
  let title: String
  let website: URL?
  let github: URL?
  let scannerLibrary: ScannerLibrary
}

let availableScanners = [
  ScannerDTO(title: "WeScan",
             website: URL(string: "https://wetransfer.com/"),
             github: URL(string: "https://github.com/WeTransfer/WeScan"),
             scannerLibrary: .weScan),
  ScannerDTO(title: "GPUImage",
             website: URL(string: "http://www.sunsetlakesoftware.com/"),
             github: URL(string: "https://github.com/BradLarson/GPUImage"),
             scannerLibrary: .gpuImage),
  ScannerDTO(title: "OpenCV",
             website: URL(string: "https://opencv.org/"),
             github: URL(string: "https://github.com/opencv"),
             scannerLibrary: .openCV)
]
