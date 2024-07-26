//
//  ViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let listView = ListView()
    private let viewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    
    let refreshAction = PublishSubject<Void>()
    let fetchMoreAction = PublishSubject<Void>()
    let saveReadNewsAction = PublishSubject<Int>()
    
    override func loadView() {
        view = listView
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
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.title = nil
    }
    
    private func setNavi() {
        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = listView.refreshButton
    }
    
    private func setTableView() {
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        listView.listTableView.tableFooterView = listView.bottomView
        listView.listTableView.tableFooterView?.isHidden = true
    }
    
    private func setGesture() {
        listView.scrollToTopButton.rx.tap
            .bind { [weak self] in
                self?.listView.listTableView.setContentOffset(.zero, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func setAction() {
        listView.refreshButton.rx.tap
            .bind { [weak self] in
                self?.refreshAction.onNext(())
                self?.listView.listTableView.setContentOffset(.zero, animated: true)
            }.disposed(by: disposeBag)
        
        listView.listTableView.rx.bottomReached
            .skip(1)
            .throttle(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.fetchMoreAction.onNext(())
            }).disposed(by: disposeBag)
        
        listView.listTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.listView.listTableView.deselectRow(at: indexPath, animated: true)
                self?.saveReadNewsAction.onNext(indexPath.row)
            }).disposed(by: disposeBag)
    }
    
    private func setBinding() {
        let input = ListViewModel.Input(refreshAction: refreshAction,
                                        fetchMoreAction: fetchMoreAction,
                                        saveReadNewsAction: saveReadNewsAction)
        
        let output = viewModel.transform(input: input)
        
        output.news
            .bind(to: listView.listTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) {
                index, item, cell in
                cell.configure(tableView: TableViewType.ListTableView, news: item)
            }.disposed(by: disposeBag)
        
        output.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] bool in
                bool ? self?.listView.indicatorView.startAnimating() : self?.listView.indicatorView.stopAnimating()
            }.disposed(by: disposeBag)
        
        output.noMoreData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.listView.bottomView.isHidden = false
                }
            }).disposed(by: disposeBag)
        
        output.apiError
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] message in
                self?.showAlert("에러", message)
            }.disposed(by: disposeBag)
        
        output.moveNews
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                self?.goNewsPage(url: url)
            }).disposed(by: disposeBag)
    }
}


// MARK: - ListViewController
extension ListViewController {
    private func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func goNewsPage(url: String) {
        let newsPageVM = NewsPageViewModel(url: url)
        let newsPageVC = NewsPageViewController(viewModel: newsPageVM)
        self.navigationController?.pushViewController(newsPageVC, animated: true)
    }
    
}
