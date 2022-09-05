//
//  MemoListView.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

import SnapKit

final class MemoListView: BaseView {
    
    let menuToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        return toolBar
    }()
    
    let memoListTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets()
        return tableView
    }()
    
    override func makeConfigures() {
        self.backgroundColor = CustomColor.backgroundColor
        [menuToolBar, memoListTableView].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        menuToolBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self).multipliedBy(0.06)
            
        }
        
        memoListTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(menuToolBar.snp.top)
        }
    }
}
