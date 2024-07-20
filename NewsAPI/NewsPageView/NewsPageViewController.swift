//
//  NewsPageViewController.swift
//  NewsAPI
//
//  Created by hansol on 2024/07/21.
//

import UIKit

class NewsPageViewController: UIViewController {
    private let newsPageView = NewsPageView()
    
    override func loadView() {
        view = newsPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
}
