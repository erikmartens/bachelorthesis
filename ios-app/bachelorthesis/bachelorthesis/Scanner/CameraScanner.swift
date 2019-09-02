//
//  CameraScanner.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 01.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import Foundation
import AVFoundation

enum ScannerLibrary {
  case metal
  case gpuImage
  case openCV
}

class CameraScanner {
  
  // MARK: - Properties
  
  private var scannerLibrary: ScannerLibrary
  
  private var videoCaptureDevice: AVCaptureDevice?
  private let videoCaptureSession = AVCaptureSession()
  private let output = AVCaptureVideoDataOutput()
  private var input: AVCaptureDeviceInput?
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  
  // MARK: - Initialization
  
  init(frame: CGRect, scannerLibrary: ScannerLibrary) {
    self.scannerLibrary = scannerLibrary
    
    videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    videoCaptureSession.sessionPreset = AVCaptureSession.Preset.photo
    
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: videoCaptureSession)
    videoPreviewLayer!.frame = frame
    videoPreviewLayer!.needsDisplayOnBoundsChange = true
    videoPreviewLayer!.videoGravity = .resizeAspectFill
    videoPreviewLayer!.connection?.videoOrientation = .portrait
    
    output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: Int(kCVPixelFormatType_32BGRA)]
    output.alwaysDiscardsLateVideoFrames = true
  }
  
  // MARK: - Functions
  
  func startCaptureSessession() {
    guard let input = try? AVCaptureDeviceInput(device: videoCaptureDevice!) else {
      return
    }
    self.input = input
    videoCaptureSession.addInput(input)
    videoCaptureSession.addOutput(output)
    videoCaptureSession.startRunning()
  }
  
  func stopCaptureSession() {
    videoCaptureSession.stopRunning()
    output.setSampleBufferDelegate(nil, queue: nil)
    videoCaptureSession.removeOutput(output)
    if let input = input {
      videoCaptureSession.removeInput(input)
    }
  }
}
