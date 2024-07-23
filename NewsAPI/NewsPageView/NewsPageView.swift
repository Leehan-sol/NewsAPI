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
    
    let progressBar: UIProgressView = {
        let pb = UIProgressView(progressViewStyle: .default)
        pb.trackTintColor = .lightGray
        pb.progressTintColor = .blue
        pb.backgroundColor = .white
        return pb
    }()
    
    let btnStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()
    
    let goForwardButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    let reloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "goforward"), for: .normal)
        return btn
    }()

    let goBackButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .systemBackground
        let stackViewSubvies = [goBackButton, reloadButton, goForwardButton]
        let subviews = [webView, progressBar, btnStackView, indicatorView]
        
        subviews.forEach { addSubview($0) }
        stackViewSubvies.forEach { btnStackView.addArrangedSubview($0) }
        
        progressBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom)
            $0.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    
        btnStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
}
