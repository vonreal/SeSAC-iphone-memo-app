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
        registerTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isEdit {
            mainView.memoTextView.becomeFirstResponder()
        }
    }
    
    func registerTextView() {
        mainView.memoTextView.delegate = self
    }
    
    func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = CustomColor.pointColor
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모"
        
        if !isEdit {
            setNavigationItems()
        }
    }
    
    func setNavigationItems() {
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
        if let allText = mainView.memoTextView.text, !allText.isEmpty {
            let activityController = UIActivityViewController(activityItems: [allText], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else {
            alertMessage(title: "공유할 메모가 없습니다.", message: "메모를 작성해주시고 다시 시도해주세요!", cancelTitle: "확인", confirmTitle: nil) {}
        }
    }
    
    @objc func finishButtonClicked() {
        
        if let allText = mainView.memoTextView.text, !allText.isEmpty {
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
        } else {
            if isEdit {
                repository.deleteData(target: task!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension WriteMemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setNavigationItems()
    }
}
