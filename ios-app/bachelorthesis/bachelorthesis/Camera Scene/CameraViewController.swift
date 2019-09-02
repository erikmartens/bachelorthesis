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
  
  @IBOutlet weak var cancelButton: FramedButton!
  @IBOutlet weak var gallerButton: FramedButton!
  @IBOutlet weak var cameraView: UIView!
  
  @IBOutlet weak var versionLabel: UILabel!
  
  // MARK: - Properties
  
  weak var scannerDelegate: ScannerDelegate!
  var selectedScannerLibrary: ScannerLibrary!
  
  private var cameraScanner: CameraScanner!
  
  // MARK: - ViewController Life Cycle
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    cancelButton.setTitle(R.string.localizable.cancel().capitalized,
                          for: UIControl.State())
    gallerButton.setTitle(R.string.localizable.picture_from_gallery(),
                          for: UIControl.State())
    
    versionLabel.text = OpenCVScannerBridge.openCVVersionString()
    
    cameraScanner = CameraScanner(frame: cameraView.frame, scannerLibrary: selectedScannerLibrary)
    cameraView.layer.addSublayer(cameraScanner.videoPreviewLayer!)
    cameraScanner.startCaptureSessession()
  }
  
  // MARK: - IBActions
  
  @IBAction func didPressCancelButton(_ sender: FramedButton) {
    cameraScanner.stopCaptureSession()
    scannerDelegate?.didCancelScanning()
  }
  
  // MARK: - Functions
}
