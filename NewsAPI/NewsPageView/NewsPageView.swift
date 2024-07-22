//
//  NewsPageView.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import WebKit

class NewsPageView: UIView {
    var webView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .systemBackground
        
        let subviews = [webView]
        
        subviews.forEach { addSubview($0) }
        
        webView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
}
