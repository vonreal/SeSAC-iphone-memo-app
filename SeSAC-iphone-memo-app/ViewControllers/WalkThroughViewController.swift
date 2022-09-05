//
//  WalkThroughViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

final class WalkThroughViewController: BaseViewController {

    private let mainView = WalkThroughView()
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
    }
    
    @objc func confirmButtonClicked() {
        UserDefaults.standard.set(true, forKey: "visited")
        self.dismiss(animated: false)
    }
}
