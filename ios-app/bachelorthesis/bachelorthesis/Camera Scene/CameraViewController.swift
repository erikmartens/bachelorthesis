//
//  CameraViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: class {
  func didCancelScanning()
  func didFinishScanning()
  func useImageGallery()
}

class CameraViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var cancelButton: FramedButton!
  @IBOutlet weak var gallerButton: FramedButton!
  @IBOutlet weak var cameraView: UIView!
  @IBOutlet weak var overlayImageView: UIImageView!
  @IBOutlet weak var versionLabel: UILabel!
  
  // MARK: - Properties
  
  weak var scannerDelegate: CameraViewControllerDelegate!
  var selectedScannerLibrary: ScannerLibrary!
  
  private var cameraScanner: CameraScanner!
  
  // MARK: - ViewController Life Cycle
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUserInterface()
    setupScanner()
  }
  
  // MARK: - IBActions
  
  @IBAction func didPressCancelButton(_ sender: FramedButton) {
    cameraScanner.stopCaptureSession()
    scannerDelegate?.didCancelScanning()
  }
  
  // MARK: - Private Functions
  
  private func setupUserInterface() {
    cancelButton.setTitle(R.string.localizable.cancel().capitalized,
                          for: UIControl.State())
    gallerButton.setTitle(R.string.localizable.picture_from_gallery(),
                          for: UIControl.State())
    
    versionLabel.text = OpenCVScannerBridge.openCVVersionString()
    overlayImageView.layer.opacity = 0.5
  }
  
  private func setupScanner() {
    cameraScanner = CameraScanner(frame: cameraView.frame, cameraScannerDelegate: self, scannerLibrary: selectedScannerLibrary)
    cameraView.layer.addSublayer(cameraScanner.videoPreviewLayer!)
    cameraScanner.videoPreviewLayer!.position = CGPoint(x: cameraView.layer.bounds.midX, y: cameraView.layer.bounds.midY)
    cameraScanner.startCaptureSessession()
  }
}

extension CameraViewController: CameraScannerDelegate {
  
  func updateOverlay(with image: UIImage) {
    DispatchQueue.main.async {
      self.overlayImageView.image = image
    }
  }
}
