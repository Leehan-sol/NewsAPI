//
//  MockAPIService.swift
//  NewsAPITests
//
//  Created by hansol on 2024/08/03.
//

import Foundation
import RxSwift

class MockAPIService: APIServiceProtocol {
    var currentStartNum = BehaviorSubject<Int>(value: 1)
    var totalCount = PublishSubject<Int>()
    
    func fetchNews(start: Int) -> Observable<[News]> {
        let mockNews = [
            News(id: "1", title: "test", content: "test", date: "test", url: "test", timeStamp: ""),
            News(id: "2", title: "test", content: "test", date: "test", url: "test", timeStamp: "")
        ]
        return Observable.just(mockNews)
    }
    
    
}
