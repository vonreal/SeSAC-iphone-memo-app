//
//  BaseViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func alertMessage(title: String, message: String, cancelTitle: String, confirmTitle: String?, completion: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle, style: .default)
        if let confirmTitle = confirmTitle {
            let ok = UIAlertAction(title: confirmTitle, style: .destructive) { action in
                completion()
            }
            alert.addAction(ok)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
