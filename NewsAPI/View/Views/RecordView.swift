//
//  RecordView.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import SnapKit


class RecordView: UIView {
    
    let recordTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    
    let scrollToTopButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.up.to.line.compact"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .gray.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "30"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let countHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "/ 30"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var naviView: UIView = {
        let view = UIView()
        view.addSubview(countLabel)
        view.addSubview(countHolderLabel)
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(countHolderLabel.snp.leading).offset(-2)
            $0.centerY.equalToSuperview()
        }
        countHolderLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var barButtonItem = UIBarButtonItem(customView: naviView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .systemBackground
        
        let subviews = [recordTableView, indicatorView, scrollToTopButton]
        
        subviews.forEach { addSubview($0) }
        
        recordTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        scrollToTopButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.width.height.equalTo(50)
        }
    }
    
}

