//
//  RecordViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import RxSwift

class RecordViewController: UIViewController {
    private let recordView = RecordView()
    private let viewModel = RecordViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = recordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavi()
        getState()
    }
    
    
    private func setNavi() {
        title = "My Record"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setTableView() {
        recordView.recordTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        //        recordView.recordTableView.tableFooterView?.isHidden = true
    }
    
    private func getState() {
        viewModel.readNews
            .bind(to: recordView.recordTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) {
                index, item, cell in
                cell.configure(tableView: TableViewType.RecordTableView, news: item)
            }.disposed(by: disposeBag)
        
    }
}

