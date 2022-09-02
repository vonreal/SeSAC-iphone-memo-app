//
//  MemoListViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/02.
//

import UIKit

class MemoListViewController: BaseViewController {

    let mainView = MemoListView()
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
        if !UserDefaults.standard.bool(forKey: "visited") {
            let viewController = WalkThroughViewController()
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.largeContentTitle = "0개의 메모"
    }

}
