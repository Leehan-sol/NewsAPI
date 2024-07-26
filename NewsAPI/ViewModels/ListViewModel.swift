//
//  ListViewModel.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import Foundation
import RxSwift
import RxCocoa

class ListViewModel {
    private let apiService = APIService()
    private let realmService = RealmService()
    private let disposeBag = DisposeBag()
    
    private let news: BehaviorSubject<[News]> = BehaviorSubject(value: [])
    private let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)// indicatorView
    private let noMoreData: BehaviorSubject<Bool> = BehaviorSubject(value: false) // bottomView
    private let apiError = PublishSubject<String>()
    private let moveNews =  PublishSubject<String>()
    
    private var currentStartNum: Int = 1
    private var totalCount: Int = 1
    
    struct Input {
        let refreshAction: PublishSubject<Void>
        let fetchMoreAction: PublishSubject<Void>
        let saveReadNewsAction: PublishSubject<Int>
    }
    
    struct Output {
        let news: BehaviorSubject<[News]>
        let isLoading: BehaviorSubject<Bool>
        let noMoreData: BehaviorSubject<Bool>
        let apiError: PublishSubject<String>
        let moveNews: PublishSubject<String>
    }
    
    func transform(input: Input)  -> Output {
        input.refreshAction
            .bind(onNext: { title in
                self.fetchNews()
            }).disposed(by: disposeBag)
        
        input.fetchMoreAction
            .bind(onNext: { title in
                self.fetchMore()
            }).disposed(by: disposeBag)
        
        input.saveReadNewsAction
            .bind(onNext: { index in
                self.saveNews(index: index)
            }).disposed(by: disposeBag)
        
        return Output(news: news,
                      isLoading: isLoading,
                      noMoreData: noMoreData,
                      apiError: apiError,
                      moveNews: moveNews)
    }
    
    
    init() {
        setBindings()
        fetchNews()
    }
    
    private func setBindings() {
        apiService.currentStartNum
            .subscribe { start in
                self.currentStartNum = start
            }.disposed(by: disposeBag)
        
        apiService.totalCount
            .subscribe { count in
                self.totalCount = count
            }.disposed(by: disposeBag)
    }
    
    private func fetchNews(start: Int = 1) {
        isLoading.onNext(true)
        apiService.fetchNews(start: start)
            .do(onError: { error in
                self.handleError(error)
                self.isLoading.onNext(false)
            })
            .subscribe(onNext: { news in
                if self.currentStartNum == 1 {
                    self.news.onNext(news)
                } else {
                    let currentNewsLists = (try? self.news.value()) ?? []
                    self.news.onNext(currentNewsLists + news)
                    print("뉴스 count:", currentNewsLists.count)
                }
                self.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    private func fetchMore() {
        print(#function)
        if currentStartNum < 1000 && currentStartNum < totalCount {
            fetchNews(start: currentStartNum + 10)
            print("currentStartNum: ", currentStartNum)
        } else {
            noMoreData.onNext(true)
        }
    }
    
    private func saveNews(index: Int) {
        guard let selectedNews = try? news.value()[index] else { return }
        realmService.saveReadNews(news: selectedNews)
        moveNews.onNext(selectedNews.url)
    }
    
    private func handleError(_ error: Error) {
        if let error = error as? APIService.APIError {
            apiError.onNext(error.errorMessage)
        } else {
            apiError.onNext("기타 에러 발생")
        }
    }
    
    
}
