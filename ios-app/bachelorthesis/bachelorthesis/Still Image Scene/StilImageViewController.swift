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
  @IBOutlet weak var resultTypeSegmentedControl: UISegmentedControl!
  
  @IBOutlet weak var selectImageButton: FramedButton!
  @IBOutlet weak var processImageButton: FramedButton!
  @IBOutlet weak var saveImageButton: FramedButton!
  
  // MARK: - Properties
  
  private lazy var imagePicker: ImagePicker = {
    return ImagePicker(presentationController: self, delegate: self)
  }()
  
  private lazy var openCvProcessorBridge: OpenCvProcessorBridge = {
    return OpenCvProcessorBridge()
  }()
  
  private var selectedImage: UIImage? {
    didSet {
      defer {
        resultImageView.isHidden = true
        sourceOpacityControlsContainer.isHidden = true
        resultOpacityControlsContainer.isHidden = true
      }
      guard let image = selectedImage else {
        return
      }
      sourceImageView.image = image
    }
  }
  
  private var processingResult: ImageProcessingResult? {
    didSet {
      defer {
        let shouldHide = !(processingResult?.hasContent() ?? false)
        resultImageView.isHidden = shouldHide
        sourceOpacityControlsContainer.isHidden = shouldHide
        resultOpacityControlsContainer.isHidden = shouldHide
      }
      
      if let croppedImage = processingResult?.croppedImage {
        resultImageView.image = croppedImage
        resultTypeSegmentedControl.selectedSegmentIndex = 0
      } else if let contoursImage = processingResult?.contoursImage {
        resultImageView.image = contoursImage
        resultTypeSegmentedControl.selectedSegmentIndex = 1
      } else if let intersectionsImage = processingResult?.intersectionsImage {
        resultImageView.image = intersectionsImage
        resultTypeSegmentedControl.selectedSegmentIndex = 2
      }
      
      resultTypeSegmentedControl.isHidden = processingResult?.contoursImage == nil && processingResult?.intersectionsImage == nil
      resultTypeSegmentedControl.setEnabled(processingResult?.croppedImage != nil, forSegmentAt: 0)
      resultTypeSegmentedControl.setEnabled(processingResult?.contoursImage != nil, forSegmentAt: 1)
      resultTypeSegmentedControl.setEnabled(processingResult?.intersectionsImage != nil, forSegmentAt: 2)
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
    
    resultTypeSegmentedControl.removeAllSegments()
    resultTypeSegmentedControl.insertSegment(withTitle: R.string.localizable.cropped_image().capitalized, at: 0, animated: false)
    resultTypeSegmentedControl.insertSegment(withTitle: R.string.localizable.contour_image().capitalized, at: 1, animated: false)
    resultTypeSegmentedControl.insertSegment(withTitle: R.string.localizable.intersection_image().capitalized, at: 2, animated: false)
    
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
 
  @IBAction func didSelectResultTypeSegmentedControlIndex(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case let index where index == 0:
      if let croppedImage = processingResult?.croppedImage {
        resultImageView.image = croppedImage
      }
    case let index where index == 1:
      if let contoursImage = processingResult?.contoursImage {
        resultImageView.image = contoursImage
      }
    case let index where index == 2:
      if let intersectionsImage = processingResult?.intersectionsImage {
        resultImageView.image = intersectionsImage
      }
    default:
      break
    }
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
      processingResult = openCvProcessorBridge.extractLoyaltyCardImage(selectedImage)
    }
  }
  
  @IBAction func didPressSaveImageButton(_ sender: FramedButton) {
    if let croppedImage = processingResult?.croppedImage {
      imagePicker.saveToCameraRoll(croppedImage)
    }
    if let countoursImage = processingResult?.contoursImage {
      imagePicker.saveToCameraRoll(countoursImage)
    }
    if let intersectionsImage = processingResult?.intersectionsImage {
      imagePicker.saveToCameraRoll(intersectionsImage)
    }
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
    self.processingResult = ImageProcessingResult(croppedImage: results.croppedScan.image, contoursImage: nil, intersectionsImage: nil)
    dismissImageScannerController()
  }
  
  func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    dismissImageScannerController()
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    dismissImageScannerController()
  }
}
