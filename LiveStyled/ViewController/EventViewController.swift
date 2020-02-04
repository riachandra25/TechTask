//
//  ViewController.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!

  var viewModel: EventListProvider = EventViewModel()

  private enum CellIdentifiers {
    static let event = "EventListTableViewCell"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    getEventList()
    startActivityView()
  }

}

// MARK: - UITableViewDataSource Implementation -
extension EventViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.currentCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.event) as? EventListTableViewCell else {
      fatalError("Failed to dequeue cell with identifier: 'EventListTableViewCell'")
    }
    cell.eventData = viewModel.event(at:indexPath.row)
    cell.didToggle = { [weak self] status in
      guard let self = self else {
        return
      }
      self.viewModel.toggleStatus(at: indexPath.row, status: status )
    }
    return cell
  }

}

// MARK: - UITableViewDataSourcePrefetching Implementation -
extension EventViewController: UITableViewDataSourcePrefetching {
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      self.getEventList()
    }
  }

}

extension EventViewController: AlertControl {

  private func getEventList() {

    if viewModel.isLoadedList {
      return
    }
    viewModel.getEventList() { result in

      DispatchQueue.main.async { [weak self] in
        guard let self = self else {
          return
        }
        self.loadingActivityView.stopAnimating()
        self.tableView.isHidden = false

        switch result {
        case .success( _):
          self.tableView.reloadData()
        case .failure(let error):
          let action = UIAlertAction(title: "OK", style: .default)
          self.displayAlert(with: "Alert" , message: error.localizedDescription, actions: [action])
        }
      }
    }
  }
}

private extension EventViewController {

 func setupTableView() {
    tableView.isHidden = true
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableView.automaticDimension
    tableView.prefetchDataSource = self
  }

  func startActivityView() {
    loadingActivityView.startAnimating()
    loadingActivityView.center = self.view.center
  }

  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount - 1
  }
}
