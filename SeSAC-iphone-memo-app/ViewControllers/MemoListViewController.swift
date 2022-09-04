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
//    var pinedTasks = [UserMemoList]()
    var pinedTasks: Results<UserMemoList>! {
        didSet {
            pinedTasksCount = pinedTasks.count
            mainView.memoListTableView.reloadData()
        }
    }
    var pinedTasksCount = 0
    
    var search = false
    var searchText = ""
    
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
        searchTasks = repository.filter(text: "")
        fetchFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.memoListTableView.reloadData()
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
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
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
    }
    
    func fetchFilter() {
//        for task in repository.filterByPined() {
//            pinedTasks.append(task)
//        }
        pinedTasks = repository.filterByPined()
        pinedTasksCount = pinedTasks.count
    }

}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                    "header") as! MemoListHeaderView
        
        var title = "메모"
        if pinedTasksCount > 0, section == 0, !search {
            title = "고정된 메모"
        } else {
            if search {
                title = "\(searchTasks.count)개 찾음"
            } else if tasks.isEmpty {
                title = ""
            }
        }
        view.title.text = title
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pinedTasksCount > 0, section == 0, !search {
            return pinedTasks.count
        } else {
            return search ? searchTasks.count : tasks.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        navigationItem.title =  "\(numberFormat.string(for: tasks.count + pinedTasksCount)!)개의 메모"
        if pinedTasksCount == 0, tasks.count == 0 { return 0 }
        return pinedTasksCount > 0 && !search ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MemoListTableViewCell
        
        var task = UserMemoList()
        if pinedTasksCount > 0, indexPath.section == 0, !search {
            task = pinedTasks[indexPath.row]
        } else {
            task = search ? searchTasks[indexPath.row] : tasks[indexPath.row]
        }
        if let title = task.title {
            let attributtedString = NSMutableAttributedString(string: title)
            attributtedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (title as NSString).range(of: searchText))
            cell.titleLabel.attributedText = attributtedString
        } else {
            cell.titleLabel.text = "제목 없음"
        }
        
        if let content = task.content {
            let text = content.trimmingCharacters(in: .controlCharacters)
            let attributtedString = NSMutableAttributedString(string: text)
            attributtedString.addAttribute(.foregroundColor, value: UIColor.orange, range: (text as NSString).range(of: searchText))
            cell.contentLabel.attributedText = attributtedString
        } else {
            cell.contentLabel.text = "추가 텍스트 없음"
        }
        
        // MARK: - 시간
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_KR")
        let calendar = Calendar(identifier: .iso8601)
        if calendar.isDateInToday(task.writeDate) {
            format.dateFormat = "a HH:mm"
        } else {
            let interval = Double(7)
            let todayYear = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let dateComponents = DateComponents(year: todayYear.year, month: todayYear.month, day: todayYear.day, hour: 00)
            let startDay = Date(timeInterval: -(86400 * (interval - 1)), since: calendar.date(from: dateComponents)!)
            if startDay <= task.writeDate {
                format.dateFormat = "EEEE"
            } else {
                format.dateFormat = "yyyy. MM. dd a HH:mm"
            }
        }
        cell.dateLabel.text = format.string(from: task.writeDate)
        
        cell.dateLabel.addCharacterSpacing()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = UserMemoList()
        if pinedTasksCount > 0, indexPath.section == 0, !search {
            task = pinedTasks[indexPath.row]
        } else {
            task = search ? searchTasks[indexPath.row] : tasks[indexPath.row]
        }
        
        let viewController = WriteMemoViewController()
        viewController.isEdit = true
        viewController.task = task
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var task = UserMemoList()
        if pinedTasksCount > 0, indexPath.section == 0, !search {
            task = pinedTasks[indexPath.row]
        } else {
            task = search ? searchTasks[indexPath.row] : tasks[indexPath.row]
        }
        
        let pin = UIContextualAction(style: .normal, title: "고정") { action, view, completionHandler in
            self.repository.updatePine {
                if task.pined {
                    self.pinedTasksCount -= 1
                    task.pined.toggle()
                } else {
                    if self.pinedTasksCount == 5 {
                        self.alertMessage(title: "고정 메모 초과", message: "고정 메모는 5개까지 가능합니다.", cancelTitle: "확인", confirmTitle: nil) {}
                        return
                    } else {
                        self.pinedTasksCount += 1
                        task.pined.toggle()
                    }
                }
            }
            self.fetchRealm()
        }
        pin.backgroundColor = CustomColor.pointColor
        pin.image = task.pined ? DefaultAssets.falsePinImage : DefaultAssets.truePinImage

        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var task = UserMemoList()
        if pinedTasksCount > 0, indexPath.section == 0, !search {
            task = pinedTasks[indexPath.row]
        } else {
            task = search ? searchTasks[indexPath.row] : tasks[indexPath.row]
        }
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { action, view, completionHandelr in
            self.alertMessage(title: "메모 삭제", message: "정말 메모를 삭제하시겠습니까?", cancelTitle: "아니오", confirmTitle: "삭제하기") {
                
                self.repository.deleteData(target: task)
                self.fetchRealm()
                if self.pinedTasksCount > 0 {
                    self.pinedTasksCount = self.pinedTasks.count
                }
                self.mainView.memoListTableView.reloadData()
            }
        }
        
        delete.backgroundColor = CustomColor.redPointColor
        delete.image = DefaultAssets.deleteButtonImage
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension MemoListViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        search = true
        mainView.memoListTableView.reloadData()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        search = false
        searchTasks = repository.filter(text: "")
        mainView.memoListTableView.reloadData()
        searchText = ""
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainView.memoListTableView.keyboardDismissMode = .onDrag
    }
}

extension MemoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchTasks = repository.filter(text: searchText)
            self.searchText = searchText
        }
    }
}
