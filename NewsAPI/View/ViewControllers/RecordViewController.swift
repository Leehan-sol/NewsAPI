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
    
    let saveReadNewsAction = PublishSubject<Int>()
    let deleteReadNewsAction = PublishSubject<Int>()
    
    override func loadView() {
        view = recordView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavi()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setGesture()
        setAction()
        setBinding()
    }
    
    private func setNavi() {
        title = "Read History"
        navigationItem.rightBarButtonItem = recordView.barButtonItem
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
        
        recordView.scrollToTopButton.rx.tap
            .bind { [weak self] in
                self?.recordView.recordTableView.setContentOffset(.zero, animated: true)
            }.disposed(by: disposeBag)
    }
    
    
    private func setAction() {
        recordView.recordTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.recordView.recordTableView.deselectRow(at: indexPath, animated: true)
                self?.saveReadNewsAction.onNext(indexPath.row)
            }).disposed(by: disposeBag)
        
        recordView.recordTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.recordView.recordTableView.beginUpdates()
                self?.deleteReadNewsAction.onNext(indexPath.row)
                self?.recordView.recordTableView.endUpdates()
            }).disposed(by: disposeBag)
    }
    
    private func setBinding() {
        let input = RecordViewModel.Input(saveReadNewsAction: saveReadNewsAction,
                                          deleteReadNewsAction: deleteReadNewsAction)
        
        let output = viewModel.transform(input: input)
        
        output.readNews
            .bind(to: recordView.recordTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) {
                index, item, cell in
                cell.configure(tableView: TableViewType.RecordTableView, news: item)
            }.disposed(by: disposeBag)
        
        output.readNewsCount
            .map { String($0) }
            .bind(to: recordView.countLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] bool in
                bool ? self?.recordView.indicatorView.startAnimating() : self?.recordView.indicatorView.stopAnimating()
            }.disposed(by: disposeBag)
        
        output.moveNews
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                self?.goNewsPage(url: url)
            }).disposed(by: disposeBag)
    }

    
}


// MARK: - RecordViewController
extension RecordViewController {
    private func goNewsPage(url: String) {
        let newsPageVM = NewsPageViewModel(url: url)
        let newsPageVC = NewsPageViewController(viewModel: newsPageVM)
        self.navigationController?.pushViewController(newsPageVC, animated: true)
    }
    
}
