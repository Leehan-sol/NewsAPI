//
//  MockRealmService.swift
//  NewsAPI
//
//  Created by hansol on 2024/08/13.
//

import Foundation
import RxSwift

class MockRealmService: RealmServiceProtocol {
    
    var mockNews: [News]
    
    init() {
        self.mockNews = [
            News(id: "1", title: "test", content: "test", date: "test", url: "test", timeStamp: ""),
            News(id: "2", title: "test", content: "test", date: "test", url: "test", timeStamp: "")
        ]
    }
    
    func loadReadNews() -> Observable<[News]> {
        return Observable.just(mockNews)
    }
    
    func saveReadNews(news: News) {
        mockNews.append(news)
    }
    
    func deleteReadNews(news: News) {
        mockNews.removeAll { $0.id == news.id }
    }
    
}
