//
//  ViewController.swift
//  bachelorthesis
//
//  Created by  Erik Maximilian Martens on 29.08.19.
//  Copyright © 2019  Erik Maximilian Martens. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

  // MARK: - ViewController LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = R.string.localizable.select_a_library()
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // TODO
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

    presentAlertViewController(withTitle: nil,
                               message: nil,
                               actions: actions,
                               addDefaultCancelAction: true)
  }
  
  // MARK: - TableView Data Source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return availableScanners.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mainTableViewCell, for: indexPath) as! MainTableViewCell
    cell.titleLabel.text = availableScanners[indexPath.row].title
    return cell
  }
}
