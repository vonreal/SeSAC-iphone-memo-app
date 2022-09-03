//
//  MemoListTableViewCell.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/03.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "월요일"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "배추 2포기, 고등어, 사탕4개 배추 2포기, 고등어, 사탕4개 배추 2포기, 고등어, 사탕4개배추 2포기, 고등어, 사탕4개"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        [titleLabel, dateLabel, contentLabel].forEach { self.addSubview($0) }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(20)
            make.top.equalTo(15)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(self).inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(self).offset(-20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}