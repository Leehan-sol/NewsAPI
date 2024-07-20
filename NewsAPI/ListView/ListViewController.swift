//
//  ViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit

class ListViewController: UIViewController {
    private let listView = ListView()
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
    }
    
    
    private func setNavi() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

