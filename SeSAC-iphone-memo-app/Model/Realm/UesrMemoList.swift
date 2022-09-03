//
//  UesrMemoList.swift
//  SeSAC-iphone-memo-app
//
//  Created by 나지운 on 2022/09/04.
//

import Foundation

import RealmSwift

final class UserMemoList: Object {
    @Persisted var title: String?
    @Persisted var writeDate: Date
    @Persisted var content: String?
    @Persisted var pined: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String?, writeDate: Date, content: String?, pined: Bool) {
        self.init()
        
        self.title = title
        self.writeDate = writeDate
        self.content = content
        self.pined = pined
    }
}
