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
        let mockNews = [News(id: "", title: "", content: "", date: "", url: "", timeStamp: ""),
                        News(id: "", title: "", content: "", date: "", url: "", timeStamp: "")]
        return Observable.just(mockNews)
    }
    
    
}
