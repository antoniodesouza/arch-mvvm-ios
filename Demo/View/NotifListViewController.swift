//
//  NotifListViewController.swift
//  Demo
//
//  Created by DaoNV on 5/21/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class NotifListViewController: UITableViewController, MVVM.View {
    var viewModel = NotifListViewModel() {
        didSet {
            updateView()
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        viewModel.delegate = self
        viewModel.fetch()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navi = navigationController,
            let window = AppDelegate.shared.window {
            window.rootViewController = navi
        }
        viewModel.getNotifs { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                break
            case .failure(let error):
                this.alert(error: error)
            }
            this.viewDidUpdated()
        }
    }

    func updateView() {
        guard isViewLoaded else { return }
        tableView.reloadData()
        viewDidUpdated()
    }
}

extension NotifListViewController: ViewModelDelegate {
    func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], changeType: ChangeType) {
        updateView()
    }
}

extension NotifListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let vm = viewModel.viewModelForHeaderInSection(section)
        return vm.repoFullName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell") as? NotifCell
            else { fatalError() }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - Private
extension NotifListViewController {
    fileprivate func configTable() {
        tableView.register(NotifCell.self, forCellReuseIdentifier: "NotifCell")
        tableView.dataSource = self
    }
}
