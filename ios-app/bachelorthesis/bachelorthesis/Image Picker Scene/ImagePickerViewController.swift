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
  }
  
  @IBAction func didPressProcessImageButton(_ sender: FramedButton) {
  }
  
  @IBAction func didPressSaveImageButton(_ sender: FramedButton) {
  }
}
