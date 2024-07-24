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
    
    let news: BehaviorSubject<[News]> = BehaviorSubject(value: []) // 나중에 private으로 바꾸기
    let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false) // indicatorView
    let noMoreData: BehaviorSubject<Bool> = BehaviorSubject(value: false) // bottomView
    let errorTrigger = PublishSubject<String>()
    
    private var currentStartNum: Int = 1
    private var totalCount: Int = 1
    
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
    
    func fetchNews(start: Int = 1) {
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
                }
                self.isLoading.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    //    var num = 1
    func fetchMore() {
        if currentStartNum < 1000 && currentStartNum < totalCount {
            fetchNews(start: currentStartNum + 10)
            //            fetchNews(start: 999 + num)
            //            num += 1
        } else {
            noMoreData.onNext(true)
        }
    }
    
    func saveNews(news: News) {
        realmService.saveReadNews(news: news)
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIService.APIError {
            errorTrigger.onNext(apiError.errorMessage)
        } else {
            errorTrigger.onNext("기타 에러 발생")
        }
    }
    
    
}
