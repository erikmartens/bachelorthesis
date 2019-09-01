//
//  CameraViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScannerDelegate: class {
  func didCancelScanning()
  func didFinishScanning()
  func useImageGallery()
}

class CameraViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var cameraView: UIView!
  
  // MARK: - Properties
  
  weak var scannerDelegate: ScannerDelegate?
  
  private var cameraScanner: CameraScanner!
  
  // MARK: - ViewController Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cancelButton.setTitle(R.string.localizable.cancel().capitalized,
                          for: UIControl.State())
    
    cameraScanner = CameraScanner(frame: cameraView.frame)
    cameraView.layer.addSublayer(cameraScanner.videoPreviewLayer!)
    cameraScanner.startCaptureSessession()
  }
  
  // MARK: - IBActions
  
  @IBAction func didPressCancelButton(_ sender: UIButton) {
    cameraScanner.stopCaptureSession()
    scannerDelegate?.didCancelScanning()
  }
  
  // MARK: - Functions
}
