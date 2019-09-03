//
//  AvailableScanners.swift
//  bachelorthesis
//
//  Created by Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import Foundation

struct ScannerDTO {
  let title: String
  let website: URL?
  let github: URL?
  let scannerLibrary: ScannerLibrary
}

let availableScanners = [
  ScannerDTO(title: "GPUImage",
             website: URL(string: "http://www.sunsetlakesoftware.com/"),
             github: URL(string: "https://github.com/BradLarson/GPUImage"),
             scannerLibrary: .gpuImage),
  ScannerDTO(title: "OpenCV",
             website: URL(string: "https://opencv.org/"),
             github: URL(string: "https://github.com/opencv"),
             scannerLibrary: .openCV)
]
