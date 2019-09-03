//
//  CameraViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 30.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraMode {
  case edges
  case quadrangles
  
  var title: String {
    switch self {
    case .edges: return R.string.localizable.edges()
    case .quadrangles: return R.string.localizable.quadrangles()
    }
  }
}

protocol CameraViewControllerDelegate: class {
  func didCancelScanning()
  func didFinishScanning()
  func useImageGallery()
}

class CameraViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var cancelButton: FramedButton!
  @IBOutlet weak var galleryButton: FramedButton!
  @IBOutlet weak var cameraModeButton: FramedButton!
  
  @IBOutlet weak var cameraView: UIView!
  @IBOutlet weak var edgesOverlayImageView: UIImageView!
  @IBOutlet weak var squaresOverlayImageView: UIImageView!
  
  @IBOutlet weak var versionLabel: UILabel!
  
  // MARK: - Properties
  
  weak var scannerDelegate: CameraViewControllerDelegate!
  var selectedScannerLibrary: ScannerLibrary!
  
  private var cameraScanner: CameraScanner!
  
  private var cameraMode: CameraMode = .edges {
    didSet {
      switch cameraMode {
      case .edges:
        edgesOverlayImageView.isHidden = false
        squaresOverlayImageView.isHidden = true
      case .quadrangles:
        edgesOverlayImageView.isHidden = true
        squaresOverlayImageView.isHidden = false
      }
      cameraModeButton.setTitle(cameraMode.title, for: UIControl.State())
      cameraScanner.cameraMode = cameraMode
    }
  }
  
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
  
  @IBAction func cameraModeButtonPressed(_ sender: FramedButton) {
    switch cameraMode {
    case .edges: cameraMode = .quadrangles
    case .quadrangles: cameraMode = .edges
    }
  }
  
  // MARK: - Private Functions
  
  private func setupUserInterface() {
    cancelButton.setTitle(R.string.localizable.cancel().capitalized,
                          for: UIControl.State())
    galleryButton.setTitle(R.string.localizable.picture_from_gallery(),
                           for: UIControl.State())
    cameraModeButton.setTitle(CameraMode.edges.title,
                                for: UIControl.State())
    
    versionLabel.text = OpenCVScannerBridge.openCVVersionString()
    
    edgesOverlayImageView.layer.opacity = 0.5
    squaresOverlayImageView.layer.opacity = 1.0
  }
  
  private func setupScanner() {
    cameraView.layoutIfNeeded()
    cameraScanner = CameraScanner(frame: cameraView.frame, cameraScannerDelegate: self, scannerLibrary: selectedScannerLibrary)
    cameraView.layer.addSublayer(cameraScanner.videoPreviewLayer!)
    cameraScanner.videoPreviewLayer!.position = CGPoint(x: cameraView.layer.bounds.midX, y: cameraView.layer.bounds.midY)
    cameraScanner.startCaptureSessession()
  }
}

extension CameraViewController: CameraScannerDelegate {
  
  func updateEdgesOverlay(with image: UIImage) {
    DispatchQueue.main.async {
      self.edgesOverlayImageView.image = image
    }
  }
  
  func updateSquaresOverlay(with image: UIImage) {
    DispatchQueue.main.async {
      self.squaresOverlayImageView.image = image
    }
  }
}
