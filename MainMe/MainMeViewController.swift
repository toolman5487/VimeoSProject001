//
//  MainMeViewController.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import UIKit
import SnapKit
import Combine

@MainActor
class MainMeViewController: BaseViewController {

    private let viewModel: MainMeViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: MainMeViewModel? = nil) {
        self.viewModel = viewModel ?? MainMeViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = MainMeViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        Task { await viewModel.fetchMeData() }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainMeAvartaCell.self, forCellReuseIdentifier: MainMeAvartaCell.reuseIdentifier)
        tableView.register(MainMeInfoCell.self, forCellReuseIdentifier: MainMeInfoCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.showsVerticalScrollIndicator = false
    }

    private func bindViewModel() {
        viewModel.$me
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if !isLoading {
                    self.endRefreshing()
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self else { return }
                AlertPresenter.presentError(from: self,
                                            message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }

    override func performRefresh() {
        Task { await viewModel.fetchMeData() }
    }
}

extension MainMeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.me == nil ? 0 : 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.me else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMeAvartaCell.reuseIdentifier, for: indexPath) as? MainMeAvartaCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainMeInfoCell.reuseIdentifier, for: indexPath) as? MainMeInfoCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
