//
//  MemoListHeaderView.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/03.
//

import UIKit

import SnapKit

final class MemoListHeaderView: UITableViewHeaderFooterView {
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "메모"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = CustomColor.fontColor
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: "header")
        configureContents()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        self.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.centerY.equalTo(self)
            
        }
    }
}
