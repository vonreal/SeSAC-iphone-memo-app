//
//  WriteMemoVIew.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/03.
//

import UIKit

final class WriteMemoVIew: BaseView {

    let memoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .boldSystemFont(ofSize: 15)
        return textView
    }()
    
    override func makeConfigures() {
        self.backgroundColor = CustomColor.backgroundColor
        [memoTextView].forEach { self.addSubview($0) }
    }

    override func makeConstraints() {
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(self)
            make.leading.trailing.equalTo(self).inset(20)
        }
    }
}
