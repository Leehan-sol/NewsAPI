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
        
        let subviews = [listTableView]
        
        subviews.forEach { addSubview($0) }
        
        listTableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        
    }
    
}

