//
//  MemoListView.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

class MemoListView: BaseView {

    override func makeConfigures() {
        self.backgroundColor = .white
        [].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        
    }
}
