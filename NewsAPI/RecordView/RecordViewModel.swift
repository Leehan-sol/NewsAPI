//
//  RecordViewModel.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/23.
//

import Foundation
import RxSwift

class RecordViewModel {
    
    private let realmService = RealmService()
    private let disposeBag = DisposeBag()
    
    let readNews: BehaviorSubject<[News]> = BehaviorSubject(value: [])
    let readNewsCount: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    
    init() {
        loadNews()
    }
    
    
    private func loadNews() {
        isLoading.onNext(true)
        
        realmService.loadReadNews()
            .subscribe(onNext: { [weak self] news in
                self?.readNewsCount.onNext(news.count)
                self?.readNews.onNext(news)
                self?.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    
    func saveNews(news: News) {
        realmService.saveReadNews(news: news)
    }
    
    func deleteNews(news: News) {
        realmService.deleteReadNews(news: news)
    }
    
    
}
