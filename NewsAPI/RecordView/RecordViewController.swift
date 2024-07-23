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
        setNavi()
        setTableView()
        setGesture()
        getState()
        setAction()
    }
    
    
    private func setNavi() {
        title = "My Record"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setTableView() {
        recordView.recordTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
    }
    
    private func setGesture() {
        recordView.recordTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.recordView.recordTableView.beginUpdates()
                self?.recordView.recordTableView.endUpdates()
            }).disposed(by: disposeBag)
    }
    
    
    private func getState() {
        viewModel.readNews
            .bind(to: recordView.recordTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) {
                index, item, cell in
                cell.configure(tableView: TableViewType.RecordTableView, news: item)
            }.disposed(by: disposeBag)
    }
    
    private func setAction() {
        recordView.recordTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                if let news = try? self?.viewModel.readNews.value()[indexPath.row] {
                    self?.viewModel.deleteNews(news: news)
                }
            }).disposed(by: disposeBag)
    }
    
    
}

