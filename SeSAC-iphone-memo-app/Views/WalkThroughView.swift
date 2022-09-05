//
//  WalkThroughView.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

import SnapKit

final class WalkThroughView: BaseView {

    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.foregroundColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    let welcomLabel: UILabel = {
        let label = UILabel()
        let text = """
        처음 오셨군요!
        환영합니다:)
        
        당신만의 메모를 작성하고
        관리해보세요!
        """
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .heavy)
        label.textColor = CustomColor.fontColor
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineSpacing = 4
        let attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: textStyle])
        label.attributedText = attributedText
        
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.pointColor
        button.layer.cornerRadius = 10
        let attributedText = NSAttributedString(string: "확인", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .bold), .foregroundColor: UIColor.white])
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    override func makeConfigures() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        [popupView].forEach { self.addSubview($0) }
        
        [welcomLabel, confirmButton].forEach { popupView.addSubview($0) }
    }
    
    override func makeConstraints() {
        popupView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(popupView.snp.width).multipliedBy(1)
        }
        
        welcomLabel.snp.makeConstraints { make in
            make.top.equalTo(popupView).inset(20)
            make.leading.trailing.equalTo(popupView).inset(25)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(popupView).multipliedBy(0.18)
            make.bottom.leading.trailing.equalTo(popupView).inset(20)
        }
    }

}
