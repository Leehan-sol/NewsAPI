//
//  NewsPageView.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit

class NewsPageView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .systemBackground
    }
    
}
