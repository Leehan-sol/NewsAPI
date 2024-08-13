//
//  RecordViewModel.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/23.
//

import Foundation
import RxSwift

class RecordViewModel {
    
    private let realmService: RealmServiceProtocol
    private let disposeBag = DisposeBag()
    
    let readNews: BehaviorSubject<[News]> = BehaviorSubject(value: [])
    let readNewsCount: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let moveNews = PublishSubject<String>()
    let deleteNews = PublishSubject<String>()
    
    struct Input {
        let saveReadNewsAction: PublishSubject<Int>
        let deleteReadNewsAction: PublishSubject<Int>
    }
    
    struct Output {
        let readNews: BehaviorSubject<[News]>
        let readNewsCount: BehaviorSubject<Int>
        let isLoading: BehaviorSubject<Bool>
        let moveNews: PublishSubject<String>
        let deleteNews: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        input.saveReadNewsAction
            .bind(onNext: { index in
                self.saveNews(index: index)
            }).disposed(by: disposeBag)
        
        input.deleteReadNewsAction
            .bind(onNext: { index in
                self.deleteNews(index: index)
            }).disposed(by: disposeBag)
        
        return Output(readNews: readNews,
                      readNewsCount: readNewsCount,
                      isLoading: isLoading,
                      moveNews: moveNews,
                      deleteNews: deleteNews)
    }

    
    init(realmService: RealmServiceProtocol) {
        self.realmService = realmService
        loadNews()
    }
    
    
    func loadNews() {
        isLoading.onNext(true)
        
        realmService.loadReadNews()
            .subscribe(onNext: { [weak self] news in
                self?.readNewsCount.onNext(news.count)
                self?.readNews.onNext(news)
                self?.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    
    private func saveNews(index: Int) {
        guard let selectedNews = try? readNews.value()[index] else { return }
        realmService.saveReadNews(news: selectedNews)
        moveNews.onNext(selectedNews.url)
    }
    
    func deleteNews(index: Int) {
        guard let selectedNews = try? readNews.value()[index] else { return }
        realmService.deleteReadNews(news: selectedNews)
        deleteNews.onNext(selectedNews.url)
    }
    
    
}
