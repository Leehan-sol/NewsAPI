//
//  ListView.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import SnapKit

class ListView: UIView {
    
    let listTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        return indicator
    }()
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue.withAlphaComponent(0.5)
        return refreshControl
    }()
    
    let bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        let label = UILabel()
        label.text = "더이상 뉴스가 없습니다."
        view.backgroundColor = .systemGray6
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        return view
    }()
    
    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: ListViewController.self, action: nil)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .systemBackground
        refreshButton.tintColor = .gray
    
        let subviews = [listTableView, indicatorView]
        
        subviews.forEach { addSubview($0) }
        
        listTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setTableView() {
        listTableView.refreshControl = refreshControl
        listTableView.tableFooterView = bottomView
    }
}

