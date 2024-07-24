//
//  NewsPageViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa


class NewsPageViewController: UIViewController, WKNavigationDelegate {
    private let newsPageView = NewsPageView()
    private let viewModel: NewsPageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: NewsPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = newsPageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        setTapGesture()
    }
    
    private func setWebView() {
        if let url = URL(string: viewModel.url) {
            let request = URLRequest(url: url)
            newsPageView.webView.load(request)
        }
        
        newsPageView.webView.rx.isLoading
            .bind(to: newsPageView.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        newsPageView.webView.rx.isLoading
            .map { !$0 }
            .bind(to: newsPageView.progressBar.rx.isHidden)
            .disposed(by: disposeBag)
        
        newsPageView.webView.rx.estimatedProgress
            .map { Float($0) }
            .bind(to: newsPageView.progressBar.rx.progress)
            .disposed(by: disposeBag)
        
        newsPageView.webView.rx.canGoBack
            .bind { [weak self] bool in
                self?.newsPageView.goBackButton.isHidden = !bool
            }.disposed(by: disposeBag)
        
        newsPageView.webView.rx.canGoForward
            .bind { [weak self] bool in
                self?.newsPageView.goForwardButton.isHidden = !bool
            }.disposed(by: disposeBag)
    }

    
    private func setTapGesture() {
        newsPageView.reloadButton.rx.tap
            .bind { [weak self] in
                self?.newsPageView.webView.reload()
            }.disposed(by: disposeBag)
        
        newsPageView.goBackButton.rx.tap
            .bind { [weak self] in
                self?.newsPageView.webView.goBack()
            }.disposed(by: disposeBag)
        
        newsPageView.goForwardButton.rx.tap
            .bind { [weak self] in
                self?.newsPageView.webView.goForward()
            }.disposed(by: disposeBag)
    }
    
}
