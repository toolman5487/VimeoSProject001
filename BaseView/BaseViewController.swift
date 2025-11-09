//
//  BaseViewController.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/9.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
    }

    deinit {
        refreshControl.removeTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    private func configureTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.refreshControl = refreshControl
    }

    func beginRefreshing() {
        guard !refreshControl.isRefreshing else { return }
        refreshControl.beginRefreshing()
        if tableView.contentOffset.y == 0 {
            tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        }
    }

    func endRefreshing() {
        guard refreshControl.isRefreshing else { return }
        refreshControl.endRefreshing()
    }

    @objc private func handleRefresh() {
        performRefresh()
    }

    func performRefresh() {
        endRefreshing()
    }
}
