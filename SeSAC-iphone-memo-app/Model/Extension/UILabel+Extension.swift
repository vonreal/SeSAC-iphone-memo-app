//
//  UILabel+Extension.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/04.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = -1) {
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
