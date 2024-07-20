//
//  RecordViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit

class RecordViewController: UIViewController {
    private let recordView = RecordView()
    
    override func loadView() {
        view = recordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
    }
    
    
    private func setNavi() {
        title = "My Record"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}

