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
    private let service = APIService()
    private let disposeBag = DisposeBag()
    
    
    let news: BehaviorSubject<[News]> = BehaviorSubject(value: [])
    private var currentStart: Int = 1
    
    init() {
        setBindings()
    }
    
    private func setBindings() {
        service.fetchNews()
            .do(onError: { error in
                self.handleError(error)
            })
            .subscribe(onNext: { news in
                self.news.onNext(news)
            }).disposed(by: disposeBag)
        
        service.startNum
            .subscribe { start in
                self.currentStart = start
            }.disposed(by: disposeBag)
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIService.APIError {
            print(apiError.errorMessage)
        } else {
            print("기타 오류 발생")
        }
    }
    
    
}
