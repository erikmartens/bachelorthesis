//
//  ViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 29.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit
import WeScan

class MainTableViewController: UITableViewController {

  // MARK: - ViewController LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = R.string.localizable.select_a_library()
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let selectedScannerType = availableScanners[indexPath.row].scannerLibrary
    
    switch selectedScannerType {
    case .weScan:
      presentWeScanScannerViewController()
    case .openCV, .gpuImage:
      presentCameraViewController(for: selectedScannerType)
    }
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    var actions: [String: ((UIAlertAction) -> Void)] = [:]
    
    if let websiteUrl = availableScanners[indexPath.row].website {
      actions[R.string.localizable.website()] = { [weak self] _ in
        self?.presentSafariViewController(for: websiteUrl, withTint: nil, completionHandler: nil)
      }
    }
    
    if let githubUrl = availableScanners[indexPath.row].github {
      actions[R.string.localizable.github()] = { [weak self] _ in
        self?.presentSafariViewController(for: githubUrl, withTint: nil, completionHandler: nil)
      }
    }

    presentAlertViewController(withTitle: R.string.localizable.additional_information(),
                               message: nil,
                               actions: actions,
                               addDefaultCancelAction: true,
                               style: .actionSheet)
  }
  
  // MARK: - TableView Data Source
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return R.string.localizable.select_a_framework()
    }
    return nil
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availableScanners.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mainTableViewCell, for: indexPath)!
    cell.titleLabel.text = availableScanners[indexPath.row].title
    return cell
  }
  
  // MARK: - Functions
  
  private func presentCameraViewController(for scannerLibrary: ScannerLibrary) {
    let viewController = R.storyboard.camera().instantiateInitialViewController() as! CameraViewController
    viewController.selectedScannerLibrary = scannerLibrary
    viewController.scannerDelegate = self
    present(viewController, animated: true, completion: nil)
  }
  
  private func presentWeScanScannerViewController() {
    let scannerViewController = ImageScannerController()
    scannerViewController.imageScannerDelegate = self
    present(scannerViewController, animated: true)
  }
}

extension MainTableViewController: CameraViewControllerDelegate {
  
  func didCancelScanning() {
    navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
  }
  
  func didFinishScanning() {
    
  }
  
  func useImageGallery() {
    
  }
}

extension MainTableViewController: ImageScannerControllerDelegate {
  
  func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    // You are responsible for carefully handling the error
    print(error)
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
    // The user successfully scanned an image, which is available in the ImageScannerResults
    // You are responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true)
  }
  
  func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    // The user tapped 'Cancel' on the scanner
    // You are responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true)
  }
}
