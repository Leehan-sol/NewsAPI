//
//  ViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {
    private let listView = ListView()
    private let viewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setTableView()
        getState()
    }
    
    
    private func setNavi() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setTableView() {
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
    }
    
    private func getState() {
        viewModel.news
            .bind(to: listView.listTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) { index, item, cell in
                cell.configure(with: item)
            }.disposed(by: disposeBag)
        
        
    }
}

