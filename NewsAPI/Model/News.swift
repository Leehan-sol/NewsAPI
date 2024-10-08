//
//  News.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation
import RealmSwift

class News: Object {
    @Persisted (primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var date: String
    @Persisted var url: String
    @Persisted var timeStamp: String
    
    override init() {
        super.init() // Realm 데이터 모델 기본 초기화
    }
    
    init(id: String, title: String, content: String, date: String, url: String, timeStamp: String) {
        super.init() // 사용자 정의 초기화
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.url = url
        self.timeStamp = timeStamp
    }
    
    override static func primaryKey() -> String? {
        return "url"
    }

}
