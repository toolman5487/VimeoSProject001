//
//  MainMeViewController.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import UIKit
import SnapKit

class MainMeViewController: BaseViewController {

    private let placeholderContent = MainMeInfoCell.Content(
        name: "Willy Hsu",
        location: "Taipei City, Taiwan",
        bio: "Software Developer!",
        avatarURL: URL(string: "https://developer.apple.com/assets/elements/icons/swift/swift-128x128_2x.png")
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainMeInfoCell.self, forCellReuseIdentifier: MainMeInfoCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.showsVerticalScrollIndicator = false
    }
}

extension MainMeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMeInfoCell.reuseIdentifier, for: indexPath) as? MainMeInfoCell else {
            return UITableViewCell()
        }
        cell.configure(with: placeholderContent)
        return cell
    }
}
