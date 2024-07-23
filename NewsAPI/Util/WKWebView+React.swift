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
    
    private var navigationDelegate: RxWKNavigationDelegateProxy {
        return RxWKNavigationDelegateProxy.proxy(for: base)
    }
    
    var isLoading: Observable<Bool> {
        return observeWeakly(Bool.self, "loading")
            .map { $0 ?? false }
    }
    
    var estimatedProgress: Observable<Double> {
        return observeWeakly(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }
    
//    var decidePolicy: Observable<(WKWebView, WKNavigationAction, ((WKNavigationActionPolicy) -> Swift.Void))> {
//        return navigationDelegate.decidePolicySubject.asObserver()
//    }
    
//    var didFinishNavigation: Observable<(WKWebView, WKNavigation)> {
//        return navigationDelegate.didFinishNavigationSubject.asObserver()
//    }
    
    
}

//class RxWKNavigationDelegateProxy: DelegateProxy<WKWebView, WKNavigationDelegate>, DelegateProxyType, WKNavigationDelegate {
//    
//    let decidePolicySubject = PublishSubject<(WKWebView, WKNavigationAction, ((WKNavigationActionPolicy) -> Swift.Void))>()
//    let didFinishNavigationSubject = PublishSubject<(WKWebView, WKNavigation)>()
//    
//    open class func currentDelegate(for object: WKWebView) -> WKNavigationDelegate? {
//        return object.navigationDelegate
//    }
//    
//    open class func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: WKWebView) {
//        object.navigationDelegate = delegate
//    }
//    
//    public init(webView: WKWebView) {
//        super.init(parentObject: webView, delegateProxy: RxWKNavigationDelegateProxy.self)
//    }
//    
//    static func registerKnownImplementations() {
//        self.register { RxWKNavigationDelegateProxy(webView: $0) }
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        decidePolicySubject.onNext((webView, navigationAction, decisionHandler))
//    }
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
//        didFinishNavigationSubject.onNext((webView, navigation))
//    }
//}
