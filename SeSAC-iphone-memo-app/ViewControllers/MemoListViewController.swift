//
//  MemoListViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

class MemoListViewController: BaseViewController {

    let mainView = MemoListView()
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
        if !UserDefaults.standard.bool(forKey: "visited") {
            let viewController = WalkThroughViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        navigationItem.title =  "0개의 메모"
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.delegate = self
        
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
        mainView.memoListTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "cell")
        mainView.memoListTableView.register(MemoListHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }

}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "header") as! MemoListHeaderView
        if section == 0 {
            view.title.text = "고정된 메모"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemoListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension MemoListViewController: UISearchControllerDelegate {
}
