//
//  MemoListViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

import RealmSwift
import Network

class MemoListViewController: BaseViewController {

    let mainView = MemoListView()
    let repository = UserMemoListRepository.repository
    var tasks: Results<UserMemoList>! {
        didSet {
            mainView.memoListTableView.reloadData()
        }
    }
    var searchTasks: Results<UserMemoList>! {
        didSet {
            mainView.memoListTableView.reloadData()
        }
    }
    
    var search = false
    
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
        
        // MARK: 제출 시 삭제하기
        repository.printFileLocation()
        setNavigation()
        registerTableView()
        setToolBar()
        fetchRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.memoListTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
    }
    
    func setNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
        
        navigationItem.searchController = UISearchController()
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.searchBar.placeholder = "검색"
        navigationItem.searchController?.searchBar.tintColor = CustomColor.pointColor
        navigationItem.searchController?.searchBar.setValue("취소", forKey: "cancelButtonText")
    }
    
    func registerTableView() {
        mainView.memoListTableView.delegate = self
        mainView.memoListTableView.dataSource = self
        mainView.memoListTableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "cell")
        mainView.memoListTableView.register(MemoListHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    func setToolBar() {
        let barButton = UIBarButtonItem(image: DefaultAssets.addButtonImage, style: .plain, target: self, action: #selector(addButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: MemoListView.self, action: nil)
        barButton.image = DefaultAssets.addButtonImage
        barButton.tintColor = CustomColor.pointColor
        mainView.menuToolBar.setItems([flexibleSpace, barButton], animated: true)
    }
    
    @objc func addButtonClicked() {
        let viewController = WriteMemoViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func fetchRealm() {
        tasks = repository.fetchRealm()
        searchTasks = repository.filter(text: "")
    }

}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "header") as! MemoListHeaderView
//        if section == 0 {
//            view.title.text = "고정된 메모"
//        }
        if search {
            view.title.text = "\(searchTasks.count)개 찾음"
        } else {
            view.title.text = "메모"
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        navigationItem.title =  "\(tasks.count)개의 메모"
        if search {
            return searchTasks.count
        }
        return tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemoListTableViewCell
        
        let task = search ? searchTasks[indexPath.row] : tasks[indexPath.row]
        
        if let title = task.title {
            cell.titleLabel.text = title
        } else {
            cell.titleLabel.text = "제목 없음"
        }
        
        if let content = task.content {
            cell.contentLabel.text = content.trimmingCharacters(in: .controlCharacters)
        } else {
            cell.contentLabel.text = "추가 텍스트 없음"
        }
        
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd a HH:mm"
        format.locale = Locale(identifier: "ko_KR")
        cell.dateLabel.text = format.string(from: task.writeDate)
        
        cell.titleLabel.addCharacterSpacing()
        cell.contentLabel.addCharacterSpacing()
        cell.dateLabel.addCharacterSpacing()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = WriteMemoViewController()
        viewController.isEdit = true
        viewController.task = tasks[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = tasks[indexPath.row]
        
        let pin = UIContextualAction(style: .normal, title: "고정") { action, view, completionHandler in
            self.repository.updatePine(target: task)
            self.mainView.memoListTableView.reloadData()
        }
        pin.backgroundColor = CustomColor.pointColor
        pin.image = DefaultAssets.truePinImage

        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandelr in
            let target = self.tasks[indexPath.row]
            self.repository.deleteData(target: target)
            self.mainView.memoListTableView.reloadData()
        }
        
        delete.backgroundColor = CustomColor.redPointColor
        delete.image = DefaultAssets.deleteButtonImage
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


// click할때 나오는 것 presentSearch -> willpresent -> didPresent
// cancel -> willdismiss -> diddismiss
extension MemoListViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        search = true
        mainView.memoListTableView.reloadData()
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        search = false
        mainView.memoListTableView.reloadData()
    }
}

extension MemoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchTasks = repository.filter(text: searchText)
        }
    }
}
