//
//  WalkThroughViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

class WalkThroughViewController: UIViewController {

    let mainView = WalkThroughView()
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
