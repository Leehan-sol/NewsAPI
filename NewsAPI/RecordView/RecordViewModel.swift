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
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    init() {
        loadNews()
    }
    
    
    private func loadNews() {
        isLoading.onNext(true)
        
        realmService.loadReadNews()
            .subscribe(onNext: { [weak self] news in
                print(news)
                self?.readNews.onNext(news)
                self?.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    
    func deleteNews(news: News) {
        realmService.deleteReadNews(news: news)
    }
    
}
