//
//  String+Extenseion.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/04.
//

import UIKit

extension String {

    func highlightText(pointColor: UIColor, targetText: String) -> NSMutableAttributedString {
        let attributtedString = NSMutableAttributedString(string: self)
        attributtedString.addAttribute(.foregroundColor, value: pointColor, range: (self as NSString).range(of: targetText))
        return attributtedString
    }

}
