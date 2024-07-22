//
//  NewsPageViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit

class NewsPageViewController: UIViewController {
    private let newsPageView = NewsPageView()
    private let viewModel: NewsPageViewModel
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setUI()
        
    }
    
    
    private func setNavi() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setUI() {
        if let url = URL(string: viewModel.url) {
            let request = URLRequest(url: url)
            newsPageView.webView.load(request)
        }
    }
    
    
    
}
