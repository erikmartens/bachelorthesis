//
//  ImagePickerViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 04.09.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import Foundation

protocol ImagePickerViewControllerDelegate: class {
  func didCancelImagePicker()
}

class ImagePickerViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var selectImageButton: FramedButton!
  @IBOutlet weak var processImageButton: FramedButton!
  @IBOutlet weak var saveImageButton: FramedButton!
  
  // MARK: - Properties
  
  private lazy var imagePicker: ImagePicker = {
    return ImagePicker(presentationController: self, delegate: self)
  }()
  
  private var selectedImage: UIImage? {
    didSet {
      guard let image = selectedImage else {
        return
      }
      imageView.image = image
    }
  }
  
  weak var delegate: ImagePickerViewControllerDelegate?
  var selectedScannerLibrary: ScannerLibrary!
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUserInterface()
  }
  
  // MARK: - Private Functions
  
  private func setupUserInterface() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel,
                                                       target: self,
                                                       action: #selector(cancelImagePicker(_:)))
    selectImageButton.setTitle(R.string.localizable.select_image(), for: UIControl.State())
    processImageButton.setTitle(R.string.localizable.process_image(), for: UIControl.State())
    saveImageButton.setTitle(R.string.localizable.save_image(), for: UIControl.State())
  }
  
  @objc private func cancelImagePicker(_ sender: UIBarButtonItem) {
    delegate?.didCancelImagePicker()
  }
  
  // MARK: - IBActions
  
  @IBAction func didPressSelectImageButton(_ sender: FramedButton) {
    self.imagePicker.present(from: sender)
  }
  
  @IBAction func didPressProcessImageButton(_ sender: FramedButton) {
  }
  
  @IBAction func didPressSaveImageButton(_ sender: FramedButton) {
  }
}

extension ImagePickerViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    selectedImage = image
  }
}
