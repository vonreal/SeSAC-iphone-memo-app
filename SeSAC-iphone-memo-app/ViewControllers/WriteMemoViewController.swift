//
//  WriteMemoViewController.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/03.
//

import UIKit

class WriteMemoViewController: BaseViewController {

    let mainView = WriteMemoVIew()
    let repository = UserMemoListRepository.repository
    var isEdit = false
    var task: UserMemoList?
    
    override func loadView() {
        super.loadView()
        
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        updateData()
    }
    
    func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = CustomColor.pointColor
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모"
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 0)
        menuBtn.setImage(DefaultAssets.shareButtonImage, for: .normal)
        menuBtn.addTarget(self, action: #selector(shareButtonClicked), for: UIControl.Event.touchUpInside)
        
        let shareButton = UIBarButtonItem(customView: menuBtn)
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonClicked))
        navigationItem.rightBarButtonItems = [finishButton, shareButton]
    }
    
    func updateData() {
        var allText = ""
        if let title = task?.title {
            allText = title + "\n"
        }
        allText += task?.content ?? ""
        mainView.memoTextView.text = allText
    }
    
    @objc func shareButtonClicked() {
        
    }
    
    @objc func finishButtonClicked() {
        
        if let allText = mainView.memoTextView.text {
            var title: String? = nil
            var content: String? = nil
            let splitText = allText.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
            
            if splitText.count > 0 {
                title = String(splitText[0])
            }
            if splitText.count == 2 {
                content = String(splitText[1])
            }
            let editTask = UserMemoList(title: title, writeDate: Date(), content: content, pined: false)
            
            if isEdit {
                repository.update(task: task!, editTask: editTask) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                repository.save(task: editTask) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
