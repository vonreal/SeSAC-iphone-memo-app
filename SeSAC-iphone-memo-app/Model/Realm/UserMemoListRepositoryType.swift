//
//  UserMemoListRepositoryType.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/04.
//

import Foundation

import RealmSwift
import UIKit

protocol UserMemoListRepositoryType {
    func printFileLocation()
    func fetchRealm() -> Results<UserMemoList>
    func save(task: UserMemoList, _ completionHandler: @escaping () -> ())
    func update(task: UserMemoList, editTask: UserMemoList, _ completionHandler: @escaping () -> ())
    func updatePine(handler: @escaping () -> ())
    func deleteData(target: UserMemoList)
    func filter(text: String) -> Results<UserMemoList>
    func filterByPined() -> Results<UserMemoList>
}

final class UserMemoListRepository: UserMemoListRepositoryType {
    private init() { }
    
    static let repository = UserMemoListRepository()
    
    private let localRealm = try! Realm()
    
    func printFileLocation() {
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    func fetchRealm() -> Results<UserMemoList> {
        return localRealm.objects(UserMemoList.self).sorted(byKeyPath: "writeDate", ascending: false).filter("pined == false")
    }
    
    func save(task: UserMemoList, _ completionHandler: @escaping () -> ()) {
        do {
            try localRealm.write {
                localRealm.add(task)
                print("Saved Success")
                completionHandler()
            }
        } catch {
            print(error)
        }
    }
    
    func update(task: UserMemoList, editTask: UserMemoList, _ completionHandler: @escaping () -> ()) {
        do {
            try localRealm.write {
                task.title = editTask.title
                task.content = editTask.content
                task.writeDate = editTask.writeDate
                task.pined = editTask.pined
                completionHandler()
            }
        } catch {
            print("Faile to update to realm.")
        }
    }
    
    func updatePine(handler: @escaping () -> ()) {
        do {
            try localRealm.write {
                handler()
            }
        } catch {
            print(error)
        }
    }
    
    func deleteData(target: UserMemoList) {
        do {
            try localRealm.write {
                localRealm.delete(target)
            }
        } catch {
            print(error)
        }
    }
    
    func filter(text: String) -> Results<UserMemoList> {
        return localRealm.objects(UserMemoList.self).filter("title CONTAINS '\(text)' OR content CONTAINS '\(text)'")
    }
    
    func filterByPined() -> Results<UserMemoList> {
        return localRealm.objects(UserMemoList.self).sorted(byKeyPath: "writeDate", ascending: false).filter("pined == true")
    }
}
