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
    
    private let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: ListViewController.self, action: nil)
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
        setTableView()
        getState()
        setAction()
    }
    
    private func setNavi() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        refreshButton.tintColor = .gray
        navigationItem.rightBarButtonItem = refreshButton
    
    }
    
    private func setTableView() {
        listView.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        listView.listTableView.tableFooterView?.isHidden = true
    }

    private func getState() {
        viewModel.news
            .bind(to: listView.listTableView.rx.items(cellIdentifier: "listCell", cellType: ListTableViewCell.self)) {
                index, item, cell in
                cell.configure(tableView: TableViewType.ListTableView, news: item)
            }.disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] bool in
                bool ? self?.listView.indicatorView.startAnimating() : self?.listView.indicatorView.stopAnimating()
            }.disposed(by: disposeBag)
        
        viewModel.endRefresh
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.listView.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        viewModel.noMoreData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.listView.bottomView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorTrigger
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] message in
                self?.showAlert("에러", message)
            }.disposed(by: disposeBag)
    }
    
    private func setAction() {
        refreshButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.fetchNews()
                self?.listView.listTableView.setContentOffset(.zero, animated: true)
            }
            .disposed(by: disposeBag)
        
        listView.listTableView.rx.bottomReached
            .skip(1)
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchMore()
            }).disposed(by: disposeBag)
        
        listView.refreshControl.rx.controlEvent(.valueChanged)
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchNews()
            }).disposed(by: disposeBag)
        
        listView.listTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.listView.listTableView.deselectRow(at: indexPath, animated: true)
                guard let selectedNews = try? self?.viewModel.news.value()[indexPath.row] else { return }
                self?.viewModel.saveNews(news: selectedNews)
                self?.goNewsPage(url: selectedNews.url)
            }).disposed(by: disposeBag)
    }
    
    
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

