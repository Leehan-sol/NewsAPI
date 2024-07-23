//
//  ListTableViewCell.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/22.
//

import UIKit

enum TableViewType {
    case ListTableView
    case RecordTableView
}

class ListTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        return label
    }()
    
    let wathcedLabel: UILabel = {
        let label = UILabel()
        label.text = "Recently Watched"
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        label.textColor = .darkGray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        label.textColor = .darkGray
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "본문"
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        label.numberOfLines = 4
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        let subviews = [titleLabel, wathcedLabel, dateLabel, descriptionLabel]
        
        subviews.forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        wathcedLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(tableView: TableViewType, news: News) {
        let date = tableView == .ListTableView ? news.date : news.timeStamp
        let bool = tableView == .ListTableView ? true : false
    
        titleLabel.text = news.title
        dateLabel.text = date
        descriptionLabel.text = news.content
        wathcedLabel.isHidden = bool
    }
}
