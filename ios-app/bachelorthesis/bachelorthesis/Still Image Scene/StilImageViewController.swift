//
//  StillImageViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 04.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import Foundation
import WeScan

protocol StillImageViewControllerDelegate: class {
  func didCancelImagePicker()
}

class StillImageViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var sourceImageView: UIImageView!
  @IBOutlet weak var resultImageView: UIImageView!
  
  @IBOutlet weak var sourceOpacityControlsContainer: UIStackView!
  @IBOutlet weak var sourceOpacityDescriptionLabel: UILabel!
  @IBOutlet weak var sourceOpacitySlider: UISlider!
  
  @IBOutlet weak var resultOpacityControlsContainer: UIStackView!
  @IBOutlet weak var resultOpacityDescriptionLabel: UILabel!
  @IBOutlet weak var resultOpacitySlider: UISlider!
  
  @IBOutlet weak var selectImageButton: FramedButton!
  @IBOutlet weak var processImageButton: FramedButton!
  @IBOutlet weak var saveImageButton: FramedButton!
  
  // MARK: - Properties
  
  private lazy var imagePicker: ImagePicker = {
    return ImagePicker(presentationController: self, delegate: self)
  }()
  
  private lazy var openCvProcessor: OpenCvProcessorBridge = {
    return OpenCvProcessorBridge()
  }()
  
  private var selectedImage: UIImage? {
    didSet {
      guard let image = selectedImage else {
        return
      }
      sourceImageView.image = image
    }
  }
  
  private var processedImage: UIImage? {
    didSet {
      defer {
        resultImageView.isHidden = processedImage == nil
        sourceOpacityControlsContainer.isHidden = processedImage == nil
        resultOpacityControlsContainer.isHidden = processedImage == nil
      }
      guard let image = processedImage else { return }
      resultImageView.image = image
    }
  }
  
  weak var delegate: StillImageViewControllerDelegate?
  var selectedScannerLibrary: ScannerLibrary!
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUserInterface()
  }
  
  // MARK: - Private Functions
  
  private func setupUserInterface() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                                        target: self,
                                                        action: #selector(cancelStillImageController(_:)))
    sourceOpacityControlsContainer.isHidden = true
    resultOpacityControlsContainer.isHidden = true
    
    resultOpacityDescriptionLabel.text = R.string.localizable.result_image_opacity()
    selectImageButton.setTitle(R.string.localizable.select_image(), for: UIControl.State())
    processImageButton.setTitle(R.string.localizable.process_image(), for: UIControl.State())
    saveImageButton.setTitle(R.string.localizable.save_image(), for: UIControl.State())
  }
  
  @objc private func cancelStillImageController(_ sender: UIBarButtonItem) {
    delegate?.didCancelImagePicker()
  }
  
  // MARK: - IBActions
  
  @IBAction func hideSourceImageButtonPressed(_ sender: UIButton) {
    UIView.animate(withDuration: 0.5) {
      self.sourceOpacitySlider.value = 0.0
      self.sourceImageView.alpha = 0.0
    }
  }
  
  @IBAction func showSourceImageButtonPressed(_ sender: UIButton) {
    UIView.animate(withDuration: 0.5) {
      self.sourceOpacitySlider.value = 1.0
      self.sourceImageView.alpha = 1.0
    }
  }
  
  @IBAction func hideResultImageButtonPressed(_ sender: UIButton) {
    UIView.animate(withDuration: 0.5) {
      self.resultOpacitySlider.value = 0.0
      self.resultImageView.alpha = 0.0
    }
  }
  
  @IBAction func showResultImageButtonPressed(_ sender: Any) {
    UIView.animate(withDuration: 0.5) {
      self.resultOpacitySlider.value = 1.0
      self.resultImageView.alpha = 1.0
    }
  }
  
  @IBAction func resultOpacitySliderValueChanged(_ sender: UISlider) {
    resultImageView.alpha = CGFloat(sender.value)
  }
  
  @IBAction func sourceOpacitySliderValueChanged(_ sender: UISlider) {
    sourceImageView.alpha = CGFloat(sender.value)
  }
 
  @IBAction func didPressSelectImageButton(_ sender: FramedButton) {
    self.imagePicker.present(from: sender)
  }
  
  @IBAction func didPressProcessImageButton(_ sender: FramedButton) {
    guard let selectedScannerLibrary = selectedScannerLibrary,
      let selectedImage = selectedImage else {
      return
    }
    switch selectedScannerLibrary {
    case .weScan:
      let scannerViewController = ImageScannerController(image: selectedImage)
      scannerViewController.imageScannerDelegate = self
      present(scannerViewController, animated: true)
    case .gpuImage:
      break
    case .openCV:
      processedImage = openCvProcessor.extractLoyaltyCardImage(selectedImage)
    }
  }
  
  @IBAction func didPressSaveImageButton(_ sender: FramedButton) {
    guard let processedImage = processedImage else {
      return
    }
    imagePicker.saveToCameraRoll(processedImage)
  }
}

extension StillImageViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    selectedImage = image
  }
}

extension StillImageViewController: ImageScannerControllerDelegate {
  
  private func dismissImageScannerController() {
    navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
    processedImage = results.croppedScan.image
    dismissImageScannerController()
  }
  
  func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    dismissImageScannerController()
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    dismissImageScannerController()
  }
}
