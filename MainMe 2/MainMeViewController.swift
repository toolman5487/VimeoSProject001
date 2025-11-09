//
//  MainMeViewController.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import UIKit

class MainMeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
       
    }
}

extension MainMeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    }
}
