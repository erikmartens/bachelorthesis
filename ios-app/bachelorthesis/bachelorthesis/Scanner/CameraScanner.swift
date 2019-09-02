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

protocol CameraScannerDelegate: class {
  func updateOverlay(with image: UIImage)
}

class CameraScanner: NSObject {
  
  private static let scannerQueue = DispatchQueue.global(qos: .userInitiated)
  
  // MARK: - Properties
  
  private weak var cameraScannerDelegate: CameraScannerDelegate?
  private var scannerLibrary: ScannerLibrary
  
  private var videoCaptureDevice: AVCaptureDevice?
  private let videoCaptureSession = AVCaptureSession()
  private let output = AVCaptureVideoDataOutput()
  private var input: AVCaptureDeviceInput?
  
  private var openCvScanner: OpenCVScannerBridge?
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  
  // MARK: - Initialization
  
  init(frame: CGRect, cameraScannerDelegate: CameraScannerDelegate, scannerLibrary: ScannerLibrary) {
    self.cameraScannerDelegate = cameraScannerDelegate
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
    
    output.setSampleBufferDelegate(self, queue: CameraScanner.scannerQueue)
    
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
  
  // MARK: - Private Functions
  
  private func precoessOutput(_ sampleBuffer: CMSampleBuffer) {
    switch scannerLibrary {
    case .metal:
      break
    case .gpuImage:
      break
    case .openCV:
      if openCvScanner == nil {
        openCvScanner = OpenCVScannerBridge()
      }
      let currentOrientation = AVCaptureVideoOrientation(from: UIDevice.current.orientation) ?? .portrait
      let resultImage = openCvScanner!.extractEdges(from: sampleBuffer, with: currentOrientation)
      cameraScannerDelegate?.updateOverlay(with: resultImage)
    }
  }
}

extension CameraScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
  
  func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    precoessOutput(sampleBuffer)
  }
  
  func captureOutput(_ captureOutput: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // nothing to do here
  }
}
