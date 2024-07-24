//
//  WKWebView+React.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/23.
//

import Foundation
import WebKit
import RxSwift
import RxCocoa

extension Reactive where Base: WKWebView {
    
    var canGoBack: Observable<Bool> {
        return base.rx.observe(Bool.self, "canGoBack")
            .map { $0 ?? false }
            .distinctUntilChanged()
    }
    
    var canGoForward: Observable<Bool> {
        return base.rx.observe(Bool.self, "canGoForward")
            .map { $0 ?? false }
            .distinctUntilChanged()
    }
    
    var isLoading: Observable<Bool> {
        return observeWeakly(Bool.self, "loading")
            .map { $0 ?? false }
    }
    
    var estimatedProgress: Observable<Double> {
        return observeWeakly(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }
    
}

